#!/usr/bin/env python
# -*- coding: utf-8 -*-
from gluon import *

import datetime, codecs, os

def path_sett():
    'devuelve el path al archivo app_settings'
    return os.path.join(current.request.folder,'models','app_settings.py')

def filter_menu(menu,prefix=''):
    '''Analiza la estructura de directorios, eliminando los items
    del menu que no estén habilitados. Elimina también los menues
    que tengan submenúes cuyos items estén todos inhabilitados
    '''
    loc={}
    execfile(path_sett(),globals(),loc) #para leer app_settings los menues no habilitados
    menu_list=[]
    for menu_item in menu:
        if len(menu_item) < 4 or not menu_item[3]:
            #si no tiene submenús se lo puede agregar directamente
            if not prefix+menu_item[0] in loc['INHABILITADOS']:
                menu_list.append(menu_item)
            elif not prefix and '/default/index' in menu_item[2]:
                menu_list.append(menu_item)
        else:
            #si tiene submenús, verificar cada uno
            prefix_new=prefix+menu_item[0]+'/'
            sub_menus=filter_menu(menu_item[3],prefix_new)
            if sub_menus:
                l=list(menu_item[:-1])
                l.append(sub_menus)
                menu_list.append(tuple(l))
    return menu_list

def recursive_menu(menu,prefix=''):
    '''Lee la estructura de directorio, y genera una lista
    con cada menu y submenu 
    '''
    menu_list=[]
    for menu_item in menu:
        if len(menu_item) < 4 or not menu_item[3]:
            if not '/default/index' in menu_item[2]:
                menu_list.append(prefix+menu_item[0])
        else:
            prefix_new=prefix+menu_item[0]+'/'
            menu_list.extend(recursive_menu(menu_item[3],prefix_new))
    return menu_list

    
def read_config(menu_options):
    '''lee la configuración, y genera un diccionario
    con la lista de características a partir del recorrido de los
    menues
    '''
    loc={}
    execfile(path_sett(),globals(),loc)
    loc['caracteristicas']=recursive_menu(menu_options)
    return loc

def write_config(data,old_vars):
    '''Grabo la configuración en el archivo app_settings correspondiente
    '''
    included_keys=old_vars.keys()
    for key in ('caracteristicas','INHABILITADOS'):
        included_keys.remove(key)
    inhabilitados=old_vars['caracteristicas']
    with codecs.open(path_sett(),'wb',encoding='utf-8') as f:
        f.write(u'# -*- coding: utf-8 -*-\n\n')
        f.write('#'*78+'\n') 
        f.write(u'# Generado por el módulo manage_settings. \n') 
        f.write(u'# No modifique manualmente este código, use el menu Admin\Setup \n') 
        f.write(u'# para modificar apropiadamente las configuraciones. \n') 
        f.write('#'*78+'\n') 
        habilitados=[]
        for key,value in data.items():
            if key in included_keys:
                f.write(u"%s=%r\n"%(key.upper(),value))
                included_keys.remove(key)
            else:
                inhabilitados.remove(key)
        f.write(u'\n# Menues deshabilitados actualmente \n') 
        f.write(u'INHABILITADOS=%r\n'%inhabilitados)
        f.write(u'\n# Configuraciones no accesibles por interfaz grafica \n') 
        for key in included_keys:
            f.write(u"%s=%r\n"%(key.upper(),old_vars[key]))
