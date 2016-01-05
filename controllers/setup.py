# -*- coding: utf-8 -*-
# try something like

from manage_settings import read_config, write_config

def index(): 
    vars=read_config(menu_options)
    if request.vars['TITULO']:
        write_config(request.vars,vars)
        response.flash = u'Nueva configuración grabada'
        redirect(URL(request.application,'default','index'))

    return dict(vars=vars)
