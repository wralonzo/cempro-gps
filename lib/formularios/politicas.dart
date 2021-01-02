// import 'package:app/main.dart';
import 'package:cempro_gps/formularios/alta_form_page.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Politicas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}
String textInicial = '\n\nTÉRMINOS Y CONDICIONES DE USO, POLÍTICA DE PRIVACIDAD Y DE USO DE DATOS PERSONALES:\n\n\n';
String texto10 =  'Los presentes Términos y Condiciones de Uso de Plataformas Tecnológicas y Política de Privacidad y de Uso de Datos Personales, han sido generados por PROGRESO® para el debido conocimiento, aceptación y estricta observancia por todos los colaboradores de PROGRESO®, que con motivo de su empleo deban acceder a las TECNOLOGÍAS PROGRESO (conforme se definen más adelante).\n\n'
    + 'Deberá leer y revisar cuidadosamente los términos y condiciones para el uso, acceso y la política de privacidad y de uso de datos personales que usted proporciona e ingresa al sitio web y/o la aplicación de control de ingresos y egresos del personal, así como cualquier otra que se habilite dentro de la aplicación (en adelante las “Plataformas”), denominadas conjuntamente TECNOLOGÍAS PROGRESO.\n\n'
    + 'Para los presentes fines, por “COLABORADOR” deberá entenderse la persona que tiene un vínculo laboral con alguna de las entidades que conforman PROGRESO®, y que por fines de su empleo debe acceder a las Plataformas, y que para el efecto ha aceptado estos términos y condiciones de uso. Una vez concluya la relación laboral del COLABORADOR, la autorización de acceso a dichas plataformas quedará inmediatamente revocada.\n\n'
    + 'Para la efectiva utilización de las TECNOLOGÍAS PROGRESO, PROGRESO® le podrá requerir ciertos datos personales para la utilización de las plataformas tecnológicas o bien verificar la autenticidad del usuario. Para efectos del presente documento se entenderá́ por Datos Personales toda aquella información que el Colaborador provea al momento de contacto y/o ingreso con las TECNOLOGÍAS PROGRESO, y que individualmente permita'
    + 'su identificación inequívoca. Esto incluye, entre otros, su nombre, datos generales de ley, número de teléfono, documento personal de identificación, fecha de nacimiento, correlativo dentro de la organización, dirección de correo electrónico y domicilio.\n\n'
    + 'La aceptación de los presentes términos y condiciones de uso, constituye condición esencial para que el COLABORADOR pueda hacer uso de las Plataformas Tecnológicas de PROGRESO®. Al iniciar el contacto con Progreso al COLABORADOR se le desplegará un mensaje indicándole que se requiere la aceptación de estos Términos y Condiciones de Uso y Política de Privacidad, y si decide continuar con el uso de las Plataformas se entiende que han sido expresamente aceptados y sin reserva por el COLABORADOR. En caso de no aceptarlas, no será posible la instalación de las plataformas.\n\n'
    + 'Mediante las plataformas tecnológicas se persiguen facilitar a los COLABORADORES de PROGRESO® una herramienta de trabajo, mediante la cual podrán realizar las siguientes funcionalidades:'
    + '\n\n a)	Confirmar su ubicación en tiempo real,'
    + '\n b)	Ingresar sus datos de geolocalización,'
    + '\n c)	Determinar rutas de seguimiento,'
    + '\n d)	Ingresar su hora de ingreso a las instalaciones,'
    + '\n e)	Ingresar su hora de egreso de las instalaciones,'
    + '\n f) 	Interacción con las plataformas de control de viáticos que existan implementados en el presente o en el futuro en PROGRESO®, incluyendo la plataforma tecnológica SAP Concur.'
    + '\n h)	Cualquier otro que PROGRESO® considere necesario o habilite, de tiempo en tiempo, para la consecución de los fines que persiguen las plataformas.\n\n'
    + '\n\nEl simple uso y/o acceso a las Plataformas por el COLABORADOR, conlleva la aceptación expresa de los Términos y Condiciones por parte de éste, quien a su vez se obliga a cumplir con las disposiciones legales y reglamentarias correspondientes.\n\n'
    + 'El COLABORADOR se obliga a no usar el sitio ni la aplicación con fines fraudulentos, así como a no llevar a cabo conducta alguna que pudiera dañar la imagen, los intereses y los derechos de las distintas entidades que conforman PROGRESO® o de terceros. Asimismo, el COLABORADOR se compromete a no realizar acto alguno que impidiera, de cualquier forma, la utilización normal y funcionamiento de las Plataformas. En caso el COLABORADOR'
    + 'no estuviere de acuerdo con los Términos y Condiciones, se deberá abstener de utilizar y/o consultar la información de las Plataformas. Por lo que el uso de la aplicación es de uso estrictamente personal y no está permitido la instalación de la misma en múltiples dispositivos de forma simultánea.  De igual forma el marcaje de otro compañero queda terminantemente prohibido por lo que hacerlo constituirá una falta al COVEC según lo que establece el mismo en su parte de “seguridad informática” y las sanciones a aplicarse.\n\n'
    + 'PROGRESO® se reserva el derecho de modificar en cualquier momento los presentes Términos y Condiciones de Uso y Política de Privacidad y de Uso de Datos Personales, así como modificar, suspender, cancelar o restringir el contenido de las Plataformas, todo sin necesidad de notificación al COLABORADOR o autorización del mismo, bastando únicamente la publicación digital de las modificaciones respectivas en las Plataformas, según aplique.\n\n'
    + 'El COLABORADOR acepta que es el único y exclusivo responsable de las claves y accesos, según la Política de Administración de Usuarios de Acceso (SAG-CP-TI-PO-04), las cuales son de carácter personal e intransferibles, que le han sido proporcionados por  PROGRESO® para acceder a las Plataformas, obligándose desde ya a custodiarlas y administrarlas apropiadamente, desligando y liberando de toda responsabilidad a las entidades que conforman PROGRESO®, por cualquier mal uso que de las mismas pueda hacerse, incluyendo pero no'
    + 'limitándose al robo o suplantación de las mismas por actos o sucesos ajenos a las referidas entidades, por lo que toda operación realizada utilizando la o las claves y accesos entregados a EL COLABORADOR, se considerarán como efectuadas por el COLABORADOR (sea directamente por él o con su consentimiento). En caso de pérdida de cualquiera de las claves y accesos que reciba, se obliga a informar inmediatamente de tal suceso a la entidad de PROGRESO® que corresponda siguiendo la Política de Robo de Equipo (SAG-CP-TI-PO-18) en '
    + 'la cual se establece que se debe reportar al teléfono 23389191. El COLABORADOR deberá proporcionar a las entidades que conforman PROGRESO® toda aquella información y datos que éstas le requieran de tiempo en tiempo. El COLABORADOR declara y garantiza que la información proporcionada por él, en este sitio o en cualquier momento y forma, es verdadera y que tiene la plena disposición de la misma.\n\n'
    + 'El COLABORADOR acepta y reconoce expresamente que:\n\n'
    + '(i) No podrá utilizar la información y/o herramientas que se brindan a través de las plataformas para fines distintos para los cuales fue creada y para los cuales ha sido habilitada por PROGRESO®;\n\n'
    + '(ii) No podrá alterar o modificar en forma alguna la información, diseños, códigos, y demás información de las Plataformas ya que el hacerlo constituye un hecho ilícito que le permite a las entidades que conforman PROGRESO® deducir las responsabilidades legales correspondientes, sin perjuicio de imponer las sanciones administrativas y/o laborales que correspondan al COLABORADOR.\n\n'
    + '(iii) Las tecnologías que se ponen a la disposición son herramientas exclusivas en cuyo desarrollo ha invertido PROGRESO®, por lo que el contenido y operatividad de las mismas son de naturaleza confidencial y reservada, materialmente valiosas. Deberá por tanto el COLABORADOR mantener la más estricta confidencialidad al respecto de las TECNOLOGÍAS PROGRESO, no permitiendo su acceso a persona alguna, sin que medie la autorización expresa de PROGRESO®, el COLABORADOR deberá de cumplir las siguientes Políticas: Procedimiento para el manejo de la comunicación organizacional (SAG-CP-ODH-PR-014) y la Política de Clasificación de la Información (SAG-CP-TI-PO-11) para cumplir con la confidencialidad y forma de compartir información sobre la misma.\n\n'
    + 'En ciertas áreas de las Plataformas, se podrán utilizar Cookies (dispositivos informáticos que permiten recabar cierta información y/o facilitar la navegación) y otros medios tecnológicos que permitan a PROGRESO® identificar, entre otros: (i) A los COLABORADORES y otras áreas de interés; (ii) El uso de las Plataformas; (iii) Saber o determinar si el COLABORADOR ha sido registrado con anterioridad o si ha utilizado el sitio otras veces. Con el simple uso de las Plataformas, el COLABORADOR acepta el uso de Cookies (u otros medios tecnológicos con fines iguales o similares). El no aceptar el uso de las Cookies (u otros medios tecnológicos con fines iguales o similares) podría impedir o afectar el acceso y/o uso correcto de las Plataformas, por lo que el COLABORADOR desde ya libera a las entidades que conforman PROGRESO® de cualquier responsabilidad proveniente de la falta de acceso y/o no funcionamiento de las Plataformas por la no aceptación por parte del COLABORADOR de la utilización de Cookies y cualesquiera otros dispositivos similares. Las entidades que conforman PROGRESO® obtienen información de las direcciones IP o la ubicación de las computadoras en el Internet con la finalidad de apoyar el diagnóstico de problemas con el servidor y administrar en forma eficiente las Plataformas, así como la veracidad de los datos siendo suministrados por el COLABORADOR al momento de utilizar las plataformas.\n\n'
    + 'Será responsabilidad exclusiva del COLABORADOR verificar que el acceso a las Plataformas sea realizado desde puntos de acceso seguros, estando obligado el COLABORADOR a verificar que esté ingresando al sitio web seguro y/o a la aplicación móvil autorizada por PROGRESO®. Las entidades que conforman PROGRESO® y su personal directamente involucrado con el desarrollo y funcionamiento de las plataformas (incluyendo a sus empleados, asesores, consultores, contratistas, accionistas, directores, gerentes, ejecutivos y demás personal) no serán responsables por cualquier tipo de daño, perjuicio, perdida, reclamaciones o gastos de cualquier tipo por el uso de las Plataformas, ni por cualquier tipo de infección por virus informáticos, ni por fallas de sistema, interrupciones del servicio o mal uso y custodia de claves, accesos y/o usuarios del COLABORADOR.\n\n'
    + 'Las entidades que conforman PROGRESO® así como el personal de cada entidad directamente relacionado con las plataformas tecnológicas (incluyendo a sus empleados, asesores, consultores, contratistas, accionistas, directores, gerentes, ejecutivos y demás personal) no se hacen responsables por los sitios web y aplicaciones móviles ajenos a las entidades que conforman PROGRESO® a los que accedan en virtud de las funcionalidades de la aplicación, a los cuales pueda acceder el COLABORADOR mediante accesos o “links” o de cualquier otro contenido puesto a disposición de terceros, por lo que será bajo exclusiva voluntad y responsabilidad de EL COLABORADOR el acceso a los mismos.\n\n'
    + 'ACEPTACIÓN DE POLÍTICA DE PRIVACIDAD Y DE USO DE DATOS PERSONALES:\n\n'
    + 'EL COLABORADOR autoriza a cualquiera de las entidades que conforman PROGRESO®, para que puedan confirmar en la forma que consideren conveniente la información suministrada/comunicada y/o cualesquiera otros datos o información suministrada. Especialmente autorizan, de conformidad con lo que estipula la Ley de Acceso a la Información Pública (Decreto 57-2008 del Congreso de la República), para que las personas o entidades que posean dicha información la puedan compartir bajo cualquier concepto y sin limitación alguna a terceros, siempre y cuando sea estrictamente para el adecuado funcionamiento de las plataformas y que en ninguna forma se comercialice la información personal de los colaboradores. En virtud de lo autorizado por este medio. EL COLABORADOR exonera de cualquier responsabilidad a cualquiera de las entidades que conforman PROGRESO® (incluyendo a sus accionistas, directores, gerentes, empleados, asesores y demás personas relacionadas con ellas) y a las entidades que prestan servicios de información, centrales de riesgo y burós de crédito, por la difusión, distribución y comercialización de su información.\n\n'
    + 'PROGRESO® no comercializará, venderá, ni compartirá la información proporcionada por el COLABORADOR, fuera de los limites antes establecidos; y en todo caso la misma será utilizada exclusivamente para los fines para los cuales fueron diseñadas y habilitadas las tecnologías.\n\n'
    ;
    String textFinal = 'LOS PRESENTES TÉRMINOS Y CONDICIONES DE USO Y POLÍTICA DE PRIVACIDAD Y DE USO DE DATOS PERSONALES MANTENDRÁN SU VIGENCIA POR TIEMPO INDEFINIDO, UNA VEZ ACEPTADOS POR EL COLABORADOR Y MIENTRAS QUE EL MISMO TENGA ACCESO A LAS PLATAFORMAS TECNOLÓGICAS.'
    + 'EL CONTENIDO DE LAS PRESENTES PODRÁ VARIAR DE TIEMPO EN TIEMPO, SIENDO OBLIGACIÓN DEL COLABORADOR REVISAR PERIÓDICAMENTE SU CONTENIDO PARA ESTAR ENTERADO DE LOS CAMBIOS REALIZADOS POR  PROGRESO®.'
    ;
int vecesPulsado = 0;
class _LoginPageState extends State<Politicas> {
  final ScrollController _scrollController = ScrollController();
    @override
    Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(
        title: new Text('Politicas'),
      ),
      body: Center(
        child: Scrollbar(
          isAlwaysShown: true,
          controller: _scrollController,
          child: ListView.builder(
              controller: _scrollController,
              itemCount: 1,
              itemBuilder: (context, index) {
                // return Card(
                  return  Column(
                      children: <Widget>[
                      // new Column(
                        new ListTile(
                          title: new Text (textInicial, textAlign: TextAlign.justify, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold )),
                        ),
                        new ListTile(
                          title: new Text (texto10, textAlign: TextAlign.justify),
                        ),
                        new ListTile(
                          title: new Text (textFinal, textAlign: TextAlign.justify, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold )),
                        ),
                        MaterialButton(
                          minWidth: 200.0,
                          height: 50.0,
                          color: Colors.green,
                          child: Text('Continuar', style: TextStyle(color: Colors.white)),
                          onPressed:  (){
                            vecesPulsado = 1;
                            Navigator.pop(
                                context,
                                MaterialPageRoute(builder: (context) => FormDeAlta() )
                            );
                          },
                        ),
                    ],
                  // ),
                // ),

                );
              }),
        ),
      ),
    );

}

