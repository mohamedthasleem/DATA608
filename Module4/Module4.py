# -*- coding: utf-8 -*-
"""
Created on Sun Mar 22 22:47:35 2020

@author: aisha
"""
import dash
import dash_core_components as dcc
import dash_html_components as html

import plotly.offline as py
import plotly.graph_objs as go
from plotly import tools
import plotly.express as px

import numpy as np
import pandas as pd

soql_health = ('https://data.cityofnewyork.us/resource/uvpi-gqnh.json?' +\
        '$select=health,boroname,count(tree_id) as count' +\
        '&$group=health,boroname').replace(' ', '%20')

soql_health = pd.read_json(soql_health)
soql_health = soql_health.dropna()
#print(soql_health)
soql_health_bx = soql_health.query('boroname == "Bronx"')
soql_health_br = soql_health.query('boroname == "Brooklyn"')
soql_health_qu = soql_health.query('boroname == "Queens"')
soql_health_mn = soql_health.query('boroname == "Manhattan"')
soql_health_si = soql_health.query('boroname == "Staten Island"')

soql_health_steward = ('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?' +\
        '$select=health,boroname,steward,count(tree_id) as count' +\
        '&$group=health,boroname,steward').replace(' ', '%20')

soql_health_steward = pd.read_json(soql_health_steward)
soql_health_steward = soql_health_steward.dropna()
#print(soql_health_steward)

soql_health_steward_bx = soql_health_steward.query('boroname == "Bronx"')
soql_health_steward_br = soql_health_steward.query('boroname == "Brooklyn"')
soql_health_steward_qu = soql_health_steward.query('boroname == "Queens"')
soql_health_steward_mn = soql_health_steward.query('boroname == "Manhattan"')
soql_health_steward_si = soql_health_steward.query('boroname == "Staten Island"')

app = dash.Dash()

colors = {'background':'white', 'text':'#4a4949'}

app.layout = html.Div(children=[
    html.H1('DATA 608 -Module 4 - NYC Health of various tree species',style={'textAlign':'center','color':colors['text']}),
    html.Div('Mohamed Thasleem, Kalikul Zaman',style={'textAlign':'center',
                                 'color':colors['text']}),
    dcc.Graph(id='Graph',
             figure={
            'data': [
                {'x': soql_health_bx['health'], 'y':soql_health_bx['count'], 'type': 'bar', 'name': 'Bronx'},
                {'x': soql_health_br['health'], 'y':soql_health_br['count'], 'type': 'bar', 'name': 'Brooklyn'},
                {'x': soql_health_qu['health'], 'y':soql_health_qu['count'], 'type': 'bar', 'name': 'Queens'},
                {'x': soql_health_mn['health'], 'y':soql_health_mn['count'], 'type': 'bar', 'name': 'Manhattan'},
                {'x': soql_health_si['health'], 'y':soql_health_si['count'], 'type': 'bar', 'name': 'StatenIsland'}
            ],
            'layout': {
                'title': 'Proportion of trees by health',
                'plot_bgcolor':colors['background'],
                'paper_bgcolor':colors['background'],
                'font':{'color':colors['text']}
                
            }
        }
    ),html.Div('',style={'textAlign':'center',
                                 'color':colors['text']}),
    dcc.Graph(id='Graph1',
            figure={
           'data': [
                {'x': soql_health_steward_bx['steward'], 'y':soql_health_steward_bx['count'], 'type': 'bar', 'name': 'Bronx'},
                {'x': soql_health_steward_br['steward'], 'y':soql_health_steward_br['count'], 'type': 'bar', 'name': 'Brooklyn'},
                {'x': soql_health_steward_qu['steward'], 'y':soql_health_steward_qu['count'], 'type': 'bar', 'name': 'Queens'},
                {'x': soql_health_steward_mn['steward'], 'y':soql_health_steward_mn['count'], 'type': 'bar', 'name': 'Manhattan'},
                {'x': soql_health_steward_si['steward'], 'y':soql_health_steward_si['count'], 'type': 'bar', 'name': 'StatenIsland'}
            ],
            'layout': {
                'title': 'Steward Improvement',
                'plot_bgcolor':colors['background'],
                'paper_bgcolor':colors['background'],
                'font':{'color':colors['text']}
                
            }
        }
    )
])


if __name__ == '__main__':
    app.run_server()