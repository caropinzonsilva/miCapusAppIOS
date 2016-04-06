#!flask/bin/python
from flask import Flask, jsonify, abort, make_response, request
import MySQLdb
import csv
import time
import smtplib
import json
from datetime import date, datetime, timedelta
from email.MIMEMultipart import MIMEMultipart
from email.MIMEBase import MIMEBase
from email.MIMEText import MIMEText
from email import Encoders
import os
import collections

app = Flask(__name__)
db = MySQLdb.connect("localhost","root","moviles","moviles" )
marcas = [
    {
        'codigo': u'201113844',
        'tiempo': u'11:04:00 15/07/2015',
        'lugar': u'ML004',
        'ip': u'157.253.0.2',
        'ipaccesspoint': u'157.253.0.1',
        'ruido': u'1',
        'luz': u'2',
        'musica': u'JBalvin',
        'temperatura': u'20',
        'humedad': u'30',
        'grupo': u'201116404',
        'infoAdd': u'-'
    },
    {
        'codigo': u'201116404',
        'tiempo': u'11:04:00 15/07/2015',
        'lugar': u'ML009',
        'ip': u'157.253.0.3',
        'ipaccesspoint': u'157.253.0.1',
        'ruido': u'1',
        'luz': u'2',
        'musica': u'JBalvin',
        'temperatura': u'20',
        'humedad': u'30',
        'grupo': u'201113844',
        'infoAdd': u'-'
    }
]

@app.route('/api/marcas', methods=['GET'])
def get_marcas():
    return jsonify({'marcas': marcas})

#Para llamar:
#curl -i -H "Content-Type: application/json" -X POST -d '{"codigo":"201116404","tiempo":"11:04:00 15/07/2015"}' http://157.253.205.33:5000/api/marcas


@app.route('/api/registroAdd', methods=['POST'])
def create_marca():
    try:
        if not request.json:
            abort(400)
        fecha = request.json.get('fecha', "")
            print fecha
            dia = request.json.get('dia', "")
            print dia
            hora = request.json.get('hora', "")
            print hora
            ruido = request.json.get('ruido', "")
            print ruido
            lugar = request.json.get('lugar', "")
            print lugar
        cursor = db.cursor()
                cursor.execute("""INSERT INTO registros VALUES (%s,%s,%s,%s,%s,%s)""",(None,datetime.now().date(),long(dia),long(hora),long(ruido),lugar.encode("ascii")))
        #cursor.commit()
        print ((None,datetime.now().date(),long(dia),long(hora),long(ruido),lugar.encode("ascii")))
        #cursor.execute("""SELECT * FROM registros;""")
        #print cursor.fetchall()
        db.commit()
        cursor.close()
        #marcas.append(marca)
    except Exception as inst:
        print type(inst)     # the exception instance
        print inst.args
    return jsonify({'marca':'OK'}), 201

@app.route('/api/darSugerencia', methods=['POST'])
def dar_marcas():
    try:
        if not request.json:
            abort(400)
    dia = request.json.get('dia', "")
    print dia
    ruido = request.json.get('ruido', "")
    print ruido
    hora = request.json.get('hora', "")
    print hora
    fecha = datetime.now().date()
    print fecha
        cursor = db.cursor()
        #cursor.execute("""INSERT INTO registros VALUES (%s,%s,%s,%s,%s,%s)""",(None,datetime.now().date(),long(dia),long(hora),long(ruido),lugar.encode("ascii")))
        #cursor.commit()
        #print ((None,datetime.now().date(),long(dia),long(hora),long(ruido),lugar.encode("ascii")))
        cursor.execute("""SELECT lugar, avg(ruido), count(*) as cuenta FROM registros WHERE fecha = %s AND (ruido BETWEEN %s AND %s) AND hora = %s AND dia = %s GROUP BY lugar ORDER BY cuenta DESC;""",(fecha,(long(ruido)/10)*10,(long(ruido)/10+1)*10,long(hora),long(dia)))
        #print cursor.fetchall()
        arreglo = cursor.fetchall()
    objects_list = []
    for row in arreglo:
        d = collections.OrderedDict()
        d['lugar'] = row[0]
        #d['fecha'] = row[1].strftime("%Y-%m-%d")
        d['ruido'] = int(row[1])
        d['cuenta'] = row[2]
        #d['ruido'] = row[4]
        #d['lugar'] = row[5]
        d['confianza'] = "real"
        objects_list.append(d)
    if len(objects_list)<3:
        cursor.execute("""SELECT lugar, avg(ruido), count(*) as cuenta FROM registros WHERE (ruido BETWEEN %s AND %s) AND hora = %s AND dia = %s GROUP BY lugar ORDER BY cuenta DESC;""",((long(ruido)/10)*10,(long(ruido)/10+1)*10,long(hora),long(dia)))
        arreglo = cursor.fetchall()
        for row in arreglo:
                    d = collections.OrderedDict()
                    d['lugar'] = row[0]
                    #d['fecha'] = row[1].strftime("%Y-%m-%d")
                    d['ruido'] = int(row[1])
                    d['cuenta'] = row[2]
                    #d['ruido'] = row[4]
                    #d['lugar'] = row[5]
                    d['confianza'] = "prediccion"
                    objects_list.append(d)
    j = json.dumps(objects_list)
        print j
        #db.commit()
        cursor.close()
        #marcas.append(marca)
    except Exception as inst:
        print type(inst)     # the exception instance
        print inst.args
    return j, 201



@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)

if __name__ == '__main__':
    #cursor.execute("""SELECT * FROM registros;""")
    #print cursor.fetchall()
    #db.close()
    app.run(host= '157.253.205.30',port=80)
