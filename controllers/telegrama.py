# -*- coding: utf-8 -*-
# intente algo como
#def index(): return dict(message="hello from telegrama.py")
def subir():
    #msa.telegramas.nombrecampo.readable=False
    msa.telegramas.estado.readable=False
    msa.telegramas.estado.writable=False
    msa.telegramas.observaciones.readable=False
    msa.telegramas.observaciones.writable=False
    form = SQLFORM(msa.telegramas)
    if request.vars.imagen:
       form.vars.imagen_filename = request.vars.imagen.filename
    if form.accepts(request.vars, session):
       response.flash = 'Imagen Aceptada'
    elif form.errors:
       response.flash = 'Error al procesar'

    return dict(message="Este es el boton de subir telegrama", form=form)
