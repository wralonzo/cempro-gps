// import 'package:app/main.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Politicas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<Politicas> {
  String _status = 'no-action';

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text('Politicas De Usuario'),
    ),
    body: new Column(
        children: <Widget>[
          new Text("TÉRMINOS Y CONDICIONES DE USO, POLÍTICA DE PRIVACIDAD Y DE USO DE DATOS PERSONALES:"
            + "TÉRMINOS Y CONDICIONES DE USO, POLÍTICA DE PRIVACIDAD Y DE USO DE DATOS PERSONALES:"
            + "Los presentes Términos y Condiciones de Uso de Plataformas Tecnológicas y Política de Privacidad y de Uso de Datos Personales, han sido generados por PROGRESO® para el debido conocimiento, aceptación y estricta observancia por todos los colaboradores de PROGRESO®, que con motivo de su empleo deban acceder a las TECNOLOGÍAS PROGRESO (conforme se definen más adelante)."
            + "Deberá leer y revisar cuidadosamente los términos y condiciones para el uso, acceso y la política de privacidad y de uso de datos personales que usted proporciona e ingresa al sitio web y/o la aplicación de control de ingresos y egresos del personal, así como cualquier otra que se habilite dentro de la aplicación (en adelante las “Plataformas”), denominadas conjuntamente TECNOLOGÍAS PROGRESO."
            + "Para los presentes fines, por “COLABORADOR” deberá entenderse la persona que tiene un vínculo laboral con alguna de las entidades que conforman PROGRESO®, y que por fines de su empleo debe acceder a las Plataformas, y que para el efecto ha aceptado estos términos y condiciones de uso. Una vez concluya la relación laboral del COLABORADOR, la autorización de acceso a dichas plataformas quedará inmediatamente revocada."
            + "Para la efectiva utilización de las TECNOLOGÍAS PROGRESO, PROGRESO® le podrá requerir ciertos datos personales para la utilización de las plataformas tecnológicas o bien verificar la autenticidad del usuario. Para efectos del presente documento se entenderá́ por Datos Personales toda aquella información que el Colaborador provea al momento de contacto y/o ingreso con las TECNOLOGÍAS PROGRESO, y que individualmente permita su identificación inequívoca. Esto incluye, entre otros, su nombre, datos generales de ley, número de teléfono, documento personal de identificación, fecha de nacimiento, correlativo dentro de la organización, NIT, dirección de correo electrónico y domicilio."
            // + "La aceptación de los presentes términos y condiciones de uso, constituye condición esencial para que el COLABORADOR pueda hacer uso de las Plataformas Tecnológicas de PROGRESO®. Al iniciar el contacto con Progreso al COLABORADOR se le desplegará un mensaje indicándole que se requiere la aceptación de estos Términos y Condiciones de Uso y Política de Privacidad, y si decide continuar con el uso de las Plataformas se entiende que han sido expresamente aceptados y sin reserva por el COLABORADOR. En caso de no aceptarlas, no será posible la instalación de las plataformas."
            // + "Mediante las plataformas tecnológicas se persiguen facilitar a los COLABORADORES de PROGRESO® una herramienta de trabajo, mediante la cual podrán realizar las siguientes funcionalidades:"
            // + "a)	Confirmar su ubicación en tiempo real,"
          ),
        ],

    ),
  );
}