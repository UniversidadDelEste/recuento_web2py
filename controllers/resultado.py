# coding: utf8
import StringIO
import csv

COLORES = """000033	000066	000099	0000CC	0000FF
003300	003333	003366	003399	0033CC	0033FF
006600	006633	006666	006699	0066CC	0066FF
009900	009933	009966	009999	0099CC	0099FF
00CC00	00CC33	00CC66	00CC99	00CCCC	00CCFF
00FF00	00FF33	00FF66	00FF99	00FFCC	00FFFF
330000	330033	330066	330099	3300CC	3300FF
333300	333333	333366	333399	3333CC	3333FF
336600	336633	336666	336699	3366CC	3366FF
339900	339933	339966	339999	3399CC	3399FF
33CC00	33CC33	33CC66	33CC99	33CCCC	33CCFF
33FF00	33FF33	33FF66	33FF99	33FFCC	33FFFF
660000	660033	660066	660099	6600CC	6600FF
663300	663333	663366	663399	6633CC	6633FF
666600	666633	666666	666699	6666CC	6666FF
669900	669933	669966	669999	6699CC	6699FF
66CC00	66CC33	66CC66	66CC99	66CCCC	66CCFF
66FF00	66FF33	66FF66	66FF99	66FFCC	66FFFF
990000	990033	990066	990099	9900CC	9900FF
993300	993333	993366	993399	9933CC	9933FF
996600	996633	996666	996699	9966CC	9966FF
999900	999933	999966	999999	9999CC	9999FF
99CC00	99CC33	99CC66	99CC99	99CCCC	99CCFF
99FF00	99FF33	99FF66	99FF99	99FFCC	99FFFF
CC0000	CC0033	CC0066	CC0099	CC00CC	CC00FF
CC3300	CC3333	CC3366	CC3399	CC33CC	CC33FF
CC6600	CC6633	CC6666	CC6699	CC66CC	CC66FF
CC9900	CC9933	CC9966	CC9999	CC99CC	CC99FF
CCCC00	CCCC33	CCCC66	CCCC99	CCCCCC	CCCCFF
CCFF00	CCFF33	CCFF66	CCFF99	CCFFCC	CCFFFF
FF0000	FF0033	FF0066	FF0099	FF00CC	FF00FF
FF3300	FF3333	FF3366	FF3399	FF33CC	FF33FF
FF6600	FF6633	FF6666	FF6699	FF66CC	FF66FF
FF9900	FF9933	FF9966	FF9999	FF99CC	FF99FF
FFCC00	FFCC33	FFCC66	FFCC99	FFCCCC	FFCCFF
FFFF00	FFFF33	FFFF66	FFFF99	FFFFCC	FFFFFF
""".split()


def index():
    "Página inical de búsqueda"
    # preparo ubicaciones a elegir: [(id_ubicacion, descripcion)]
    ubicaciones = msa(msa.ubicaciones.clase.contains(["Pais", "Departamento", "Provincia"])).select()
    ubicaciones = sorted([(row.id_ubicacion, "%s (%s)" % (row.descripcion, row.clase)) 
                          for row in ubicaciones] + [(None, "")], 
                         key=lambda x: (x[0]*1000 if x[0] and x[0] < 1000 else x[0]))

    # busco todos las cargos y armo un diccionario {id_cargo: descripcion}
    cargos = dict([(c.id_cargo, c.descripcion) 
                   for c in msa().select(msa.cargos.ALL)])

    # armo formulario
    form = SQLFORM.factory(
        Field("id_ubicacion", "string", default=UBICACION_RAIZ,
            label="Ubicación",requires=IS_IN_SET(ubicaciones)),
        Field('id_cargo', type='string', default=CARGO_PRINCIPAL,
            label="Cargo", requires=IS_IN_SET(cargos)),
        Field('id_estado', type='string', default=ESTADO_FINAL,
            label="Estado", requires=IS_IN_SET(ESTADOS)), 
        )

    # proceso el formulario (valida si ha sido completado)
    if form.accepts(request.vars, session, keepvalues=True):
        id_ubicacion = form.vars.id_ubicacion.strip()
        id_cargo = form.vars.id_cargo
        id_partido = None #request.args[2]
        id_estado = form.vars.id_estado
        redirect(URL("reporte", args=[id_ubicacion, id_cargo, id_partido, id_estado]))

    return {'form': form}
    
def reporte():
    "Página de resultados: datos totalizados por ubicación y cargo"
    # obtengo las variables del requerimiento (URL)
    id_ubicacion = request.args[0]
    id_cargo = request.args[1]
    id_partido = None #request.args[2]
    id_estado = request.args[3]

    # obtengo los datos básicos para el encabezado del reporte
    ubicacion = msa(msa.ubicaciones.id_ubicacion==id_ubicacion).select().first()
    cargo = msa(msa.cargos.id_cargo==id_cargo).select().first()
    partido = None #msa(msa.partidos.id_partido==id_partido).select().first()

    # inicializar las variables de trabajo
    tabla_resultado = []
    dhont_votos = {}
    dhont_candidatos = {}
    tabla_dhont = {}
    listas = {}
    total = 0
    total_m = 0
    total_f = 0
    total_porc = 0
    dhont_total = 0
    dhont_bancas = None
    dhont_piso = None
    dhont_electos = {}
    
    # alias de tablas:       
    p = msa.planillas
    d = msa.planillas_det
    l = msa.listas

    # armo la consulta base
    query = p.id_planilla == d.id_planilla
    query &= d.id_lista == l.id_lista
    query &= p.id_estado == id_estado
    query &= d.id_cargo == id_cargo
    query &= l.positivo == True
    ##query &= l.id_partido == id_partido

    # armo la consulta recursiva (árbol) para tener las ubicaciones y planillas
    # (up -> ubicación padre, uh -> ubicación hija)
    # p/ el alias de cada tabla se usa el nombre de la clase (depto, mesa, etc.)
    up = msa.ubicaciones.with_alias(ubicacion.clase)
    query &= up.id_ubicacion == id_ubicacion
    for clase in CLASES[CLASES.index(ubicacion.clase)+1:]: 
        uh = msa.ubicaciones.with_alias(clase)
        query &= uh.id_ubicacion_padre == up.id_ubicacion
        up = uh
    query &= p.id_ubicacion == up.id_ubicacion
        
    # campo suma total:
    suma_votos = d.votos_definitivos.sum()
    
    # ejecuto la consulta:
    resultado = msa(query).select( 
              d.id_lista.with_alias("id_lista"),
              l.nro_lista.with_alias("nro_lista"), 
              l.descripcion.with_alias("descripcion"), 
              l.idx_fila.with_alias("idx_fila"), 
              l.descripcion_corta.with_alias("descripcion_corta"),
              l.color.with_alias("color"),
              suma_votos.with_alias("suma_votos"),
              groupby=(d.id_lista |
                        l.nro_lista | 
                        l.descripcion |
                        l.idx_fila |
                        l.descripcion_corta |
                        l.color),
              orderby= ~suma_votos | l.idx_fila
             )
    
    ##return msa._lastsql   # muestro query para depuración
    
    # Calculo el total y preparo datos para dhont

    for registro in resultado:
        id_lista = str(registro.id_lista)
        votos = int(registro.suma_votos or 0)
        total += votos
        total_porc += votos
        # Genero diccionarios D'Hondt para las listas positivas (resultado)
        dhont_total += votos
        if registro.nro_lista: # si no es blanco, suma al total 
            dhont_votos[id_lista] = votos
            # nesesito nombre y sexo de los catidatos!
            q = msa.candidatos.id_lista == id_lista
            q &= msa.candidatos.id_cargo == id_cargo
            q &= msa.candidatos.id_ubicacion == id_ubicacion
            q &= msa.candidatos.categoria == "Consejal Titular"

            dhont_candidatos[id_lista] = [
                (id_lista,'%d: %s Sexo: %s' % (i+1, r.nombre, r.sexo), r.sexo)
                 for i, r in enumerate(msa(q).select(orderby=msa.candidatos.idx_fila))]

    # Calculo el dhont
    dhont_total = sum(dhont_votos.values())
    dhont_piso = 0.05
    dhont_bancas = max([len(cands) for cands in dhont_candidatos.values()]) or 0

    if dhont_total:
        tabla_dhont, dhont_electos = calcula_dhont_electos(dhont_votos, dhont_total, dhont_piso, 
                                              dhont_bancas, dhont_candidatos)
    else:
        tabla_dhont, dhont_electos = [],[] # no ha datos disponibles

    # Genero las filas de la tabla (votos positivos)
    for registro in resultado:
        id_lista = str(registro.id_lista)
        if registro.nro_lista is not None:
            nro_lista = registro.nro_lista
        else:
            nro_lista = ''
        desc_lista = registro.descripcion
        listas[id_lista] = {'nro_lista': nro_lista, 'desc_lista': desc_lista}
        votos = registro.suma_votos  or 0
        if total_porc:
            porc = float(votos) / float(total_porc) * 100.00
            porc = '%3.2f%%' % porc
        else:
            porc = "---"
        
        bancas_obtenidas = '--'
        if id_lista in tabla_dhont:
            bancas_obtenidas = str(tabla_dhont[id_lista])
        tabla_resultado.append(dict(nro_lista=nro_lista, desc_lista=desc_lista, 
                                    votos=votos, porc=porc, 
                                    bancas_obtenidas=bancas_obtenidas))
    # generar el chart
    listas = []
    porcentajes= []
    colores = []
    colorind = 0
  
    for lista in tabla_resultado:
        listas.append(lista['nro_lista'])
        porcentajes.append(lista['porc'][:-2])
        if lista['nro_lista'].strip() == '131':
           colores.append("50EBEC")
        elif lista['nro_lista'].strip() == '132':
           colores.append("7200BF")
        elif lista['nro_lista'].strip() == '133':
           colores.append("7200BF")
        elif lista['nro_lista'].strip() == '135':
           colores.append("FEFF00")
        elif lista['nro_lista'].strip() == '137':
           colores.append("FF0000")
	else:
           if colorind >= len(COLORES):
              colorind = 0
           colores.append(COLORES[colorind])
           colorind += 1
     
    url = "http://chart.apis.google.com/chart?cht=p&chd=t:"+','.join(porcentajes)+"&chs=500x400&chl="+'|'.join(listas)+"&chco="+'|'.join(colores)+"&.png"
    chart = IMG(_src=url,_width="500",_height="400")

    # devuelvo los datos a la vista
    return dict(
        tabla_resultado=tabla_resultado, 
        total=total,
        dhont_total=dhont_total,
        dhont_bancas=dhont_bancas,
        dhont_piso=dhont_piso,
        dhont_votos=dhont_votos,
        dhont_electos=dhont_electos,
        tabla_dhont=tabla_dhont,
        listas=listas,
        ubicacion=ubicacion,
        cargo=cargo,
        partido=partido,
    chart=chart,
    my_args=request.args
        )


def calcula_dhont_electos(votos, total, piso, bancas, candidatos=None):
    """ 
    Calcula la cantidad de bancas obtenidas por cada lista y devuelve una lista
    de los candidatos electos teniendo en cuenta cupos por genero.

    votos: diccionario de votos. votos[lista]: Cantidad de votos para la lista
    total: total de votos. Se pasa porque podria incluir votos en blanco
    piso: porcentaje minimo de votos para participar en el D'Hont
    bancas: cantidad de bancas a repartir
    candidatos: diccionario con una lista de candidatos por cada lista que a su
                vez se compone de una tupla con los datos de los candidatos.
                candidatos[lista] = [(id candidato, descripcion, genero)]
    """
    
    # ADVERTENCIA: código experimental - no terminado ni probado
    
    sobre_piso = {}
    cocientes= {}
    resultado = {}
    electos = []

    # cortar por el piso (%)
    for k,v in votos.iteritems():
        porc = float(v) / float(total)
        if porc > piso:
            sobre_piso[k] = int(v)

    # verifico que no haya dos listas con la misma cantidad de votos:
    if len(set(sobre_piso.values())) != len(sobre_piso.values()):
        # hay empate, corresponde sorteo! (no mostrar bancas)
        return {}  #  (en blanco)

    # calculo y ordeno los cocientes
    for k,v in sobre_piso.iteritems():
        for i in range(bancas):
            coc = float(v) / float(i + 1)
            if coc not in cocientes:
                cocientes[coc] = []
            cocientes[coc].append(k)
    cocs = cocientes.keys()
    cocs.sort(reverse=True)

    ult_genero = None
    genero_acum = 0

    # busco los primeros cocientes hasta completar las bancas
    for k in cocs:
        for lista in cocientes[k]:
            if lista not in resultado:
                resultado[lista] = 0
            resultado[lista] += 1

            # Este bloque calcula el D'Hont teniendo en cuenta el cupo por genero
            if candidatos <> None:
                electo = 0

                # En el caso que los ultimos 2 sean del mismo genero busca el
                # primero de la lista que no lo sea y reinicio 
                # el contador de genero
                if genero_acum == 2:
                    while candidatos[lista][electo][2] == ult_genero:
                        electo += 1
                    genero_acum = 0

                # Si cambia el genero, reinicio el contador
                if ult_genero <> candidatos[lista][electo][2]:
                    genero_acum = 0

                # Guardo el ultimo genero
                ult_genero = candidatos[lista][electo][2]
                genero_acum += 1
                electos.append(candidatos[lista].pop(electo))

            bancas -= 1
            if bancas == 0:
                    return (resultado, electos)

    # Si me quedan bancas sin asginar, las devuelvo con clave None
    if bancas > 0:
        resultado[None] = bancas
    
    return (resultado, electos)


def exportar():
    data=reporte()
    s = StringIO.StringIO()
    rows = data['tabla_resultado']
    
    writer = csv.writer(s, dialect='excel')
    headers=["nro_lista","descripcion","votos","porc","bancas_obtenidas"]
    writer.writerow(headers)    
    for fila in data['tabla_resultado']:
        writer.writerow([fila['nro_lista'],
                fila['desc_lista'],
                fila['votos'],
                fila['porc'],
                fila['bancas_obtenidas']])

    response.headers['Content-Type'] = 'text/csv'
    return s.getvalue()

def pdfreport():
    #response.title = "web2py sample report"
    
    # include a google chart!
    url = "http://chart.apis.google.com/chart?cht=p3&chd=t:60,40&chs=250x100&chl=Hello|World&.png"
    chart = IMG(_src=url, _width="250",_height="100")

    # create a small table with some data:
    data=reporte()
    items=sorted(data['tabla_resultado'])
    pdfchart = data['chart']
    rows = [THEAD(TR(TH("Lista",_width="10%"), 
                     TH(" ",_width="60%"), 
                     TH("Votos",_width="10%"), 
                     TH("Porc.",_width="10%"), 
                     TH("Bancas",_width="10%"),_bgcolor="#A0A0A0")),
            TBODY(*[TR(TD(item["nro_lista"]),
                       TD(item["desc_lista"]),
                       TD(item["votos"]),TD(item["porc"]),
                       TD(item["bancas_obtenidas"]) ) 
                    
                    for item in items])]
    
    table = TABLE(*rows, _border="0", _width="100%", _class="table table-striped")
    if not request.extension=="pdf":
        from gluon.contrib.pyfpdf import FPDF, HTMLMixin

        # create a custom class with the required functionalities 
        class MyFPDF(FPDF, HTMLMixin):
            def header(self): 
                "hook to draw custom page header"
                #logo=os.path.join(request.env.web2py_path,"applications",request.application,"private","tutorial","logo_pb.png")
                #self.image(logo,10,8,33)
                self.set_font('Arial','B',15)
                self.cell(65) # padding
                self.cell(60,10,response.title,1,0,'C')
                #self.ln(20)
                
            def footer(self):
                "hook to draw custom page header (printing page numbers)"
                self.set_y(-15)
                self.set_font('Arial','I',8)
                txt = 'Page %s of %s' % (self.page_no(), self.alias_nb_pages())
                self.cell(0,10,txt,0,0,'C')             
        pdf=MyFPDF()
        # create a page and serialize/render HTML objects
        pdf.add_page()
        pdf.write_html(str(XML(table, sanitize=False)))
        pdf.write_html(str(XML(CENTER(pdfchart), sanitize=False)))
        # prepare PDF to download:
        response.headers['Content-Type']='application/pdf'
        return pdf.output(dest='S')
