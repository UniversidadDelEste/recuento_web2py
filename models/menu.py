# -*- coding: utf-8 -*-
import manage_settings

#########################################################################
## Customize your APP title, subtitle and menus here
#########################################################################

response.title = TITULO
response.subtitle = SUBTITULO
response.meta.author = 'Mariano Reingart <reingart@gmail.com>'
response.meta.description = 'Aplicación para procesamiento de datos electorales'
response.meta.keywords = 'elecciones recuento resultado carga definitivo'

##########################################
## this is the main application menu
## add/remove items as required
##########################################

menu_options = [
    (T('Index'), False, URL(request.application,'default','index'), []),
    (T('Consultas'), False, URL(request.application,'definitivo','index'), []),
    (T('Resultado'), False, URL(request.application,'resultado','index'), []),
    (T('Subir Telegrama'), False, URL(request.application, '',''), [
        (T('Version 1'), False, URL(request.application, 'telegrama','subir'), []),
    (T('Version 2'), False, URL(request.application, 'telegrama2','index'), []),
        ]),
    (T('ABM'), False, URL(request.application, '',''), [
        (T('Partidos Politicos'), False, URL(request.application, 'abm','partidos'), []),
        (T('Listas'), False, URL(request.application, 'abm','listas'), []),
        (T('Mesas'), False, URL(request.application, 'abm','mesas'), []),
        ]),
    ]

##########################################
## this is here to provide shortcuts
## during development. remove in production 
##
## mind that plugins may also affect menu
##########################################

menu_options+=[
    (T('Admin'), False, URL('admin', 'default', 'design/%s' % request.application),
     [
            (T('Setup'), False, URL(request.application, 'setup','index'), []),
            (T('Configuración'), False, 
             URL('admin', 'default', 'edit/%s/models/app_settings.py' \
                     % (request.application,))), 
            (T('Database'), False, 
             URL(request.application, 'appadmin', 'index')),
            ]
   ),
  ]
response.menu=manage_settings.filter_menu(menu_options)
