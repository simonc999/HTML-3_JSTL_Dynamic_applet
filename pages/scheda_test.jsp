<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>


<%------------------------------------------------------------------------%>
<%---------------  AUTORIZZAZIONE AREA LAB -------------------------------%>
<%------------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="4"/>
<c:set var="auth_page" value="home_lab.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Laboratorio"/>

<%@ include file="auth.jspf"%>


<%@ include file="top.jspf"%>
 
<form method="post" action="test.jsp"> 
    <td align="right" width="60">
            <!-- COMANDO INDIETRO -->
           
           <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
           <input type="hidden" name="presc" value="${param.test}"/>
        <input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
    </td> 
</form>

 
<%@ include file="middle.jspf"%>

<%------------------------------------------------------------------------%>
<%-------- QUERY PER ESTRARRE INFORMAZIONI RELATIVE AD UN TEST------------%>
<%------------------------------------------------------------------------%>

<sql:query var="schedatest">
    select t.id_test, t.scopo, t.risultati_attesi, tt.tipo, c.nome, p.nome_prod, t.data_ora_esito, t.superato, t.id_scheda, t.rapporto
    from TEST t, TIPO_TEST tt, SCHEDA_PROD p, CPR c
    where t.id_tipo=tt.id_tipo and p.id_scheda=t.id_scheda and p.user_cpr=c.user_cpr and t.id_test="${param.id_test}"
</sql:query>

<%---------------------------------------------------------------------------------------%>
<%-------- QUERY PER ESTRARRE INFORMAZIONI RELATIVE ALLE NOTIFICHE MAIL CON CONTEGGIO----%>
<%---------------------------------------------------------------------------------------%>

<sql:query var="mess">
SELECT m.id_messaggio
      FROM MESSAGGI m, TEST t, SCHEDA_PROD p
      WHERE t.id_test=m.id_test and t.id_scheda=p.id_scheda and m.nuovo = 1 and m.inviato = 0 and t.id_test= ? and m.user_lab="${user_userid}"
      <sql:param value="${param.id_test}"/>
</sql:query>
<c:set var="n_mess" value="${mess.rowCount}"/>

<%-------------------------------------------------------------------------------------------%>
<%-------- QUERY PER ESTRARRE INFORMAZIONI RELATIVE ALLA PRESENZA DI MAIL CON CONTEGGIO -----%>
<%-------------------------------------------------------------------------------------------%>

<sql:query var="mess1">
SELECT m.id_messaggio
      FROM MESSAGGI m, TEST t, SCHEDA_PROD p
      WHERE t.id_test=m.id_test and t.id_scheda=p.id_scheda and t.id_test= ? and m.user_lab="${user_userid}"
      <sql:param value="${param.id_test}"/>
</sql:query>
<c:set var="n_mess1" value="${mess1.rowCount}"/>

<sql:query var="prod">
   select p.uso, p.Nome_prod, p.tipo, p.beneficio, c.nome, p.materiali
   from SCHEDA_PROD p, CPR c
   where c.user_cpr=p.user_cpr and p.id_scheda="${param.id_scheda}"
</sql:query>




        <TABLE  cellspacing="0" border="0" bgcolor="#bbccdc" width="100%" height="100%" bordercolor="#41140E">
<%---------------------------------------------------------------------------%>
<%-----------------------      SEZIONE SX                     ---------------%>
<%---------------------------------------------------------------------------%>
                 <tr>
                        <td   align="center" width="65%" style="padding: 0px;border-left-width: 3px ">
                           
<%---------------------------------------------------------------------------%>
<%-----------------------     TABELLA CON SCHEDA TEST         ---------------%>
<%---------------------------------------------------------------------------%>
                            <table width="100%" height="100%"  border="0" >
                                <tr height="25%">
                                    <td width="68%"><p align="center"  style="font-size:35px;color: #008080;font-weight:bold;font-family:arial" >&nbsp DESCRIZIONE TEST</p>
                                    <p align="center"><font color="black" style="font-size:15px;font-weight:bold;font-family:arial">Descrizione del test relativo al prodotto <font color="#008080" style="font-size:15px;font-weight:bold;font-family:arial"> ${schedatest.rows[0].nome_prod}</font></font> </p>
                                   </td>
                                </tr>
                                <tr width="100%" height="35%">
                                    <td  width="100%" align="center" style="font-size:18px; font-family:arial">
                                        <table width="80%" border="0" cellspacing="0" cellpadding="3" bordercolor="bbccdc"> 
                                            <tr>
                                                <td align="left" width="15%" height="15%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial">ID TEST: </font></td>
                                                <td align="center" bgcolor="white"> ${schedatest.rows[0].id_test} </td>
                                            </tr>

                                            <tr>
                                                <td align="left" width="15%" height="25%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial">TIPO: </font></td>
                                                <td align="center" height="35%" bgcolor="white"> ${schedatest.rows[0].tipo} </td>
                                            </tr>
                                            
                                            <tr>
                                                <td align="left" width="15%" height="20%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial">SCOPO: </font></td>
                                                <td align="center"bgcolor="white"> ${schedatest.rows[0].scopo} </td>
                                            </tr>
                                            
                                            <tr>
                                                <td align="left" width="15%" height="25%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial">RISULTATI ATTESI: </font></td>
                                                <td align="center" height="35%" bgcolor="white"> ${schedatest.rows[0].risultati_attesi} </td>
                                            </tr>
                                            <c:if test="${not empty schedatest.rows[0].data_ora_esito}">
                                                <tr>
                                                    <td align="left" width="15%" height="15%" bgcolor="#007171">
                                                    <font color="#9ad6d6" face="Arial">ESITO: </font></td>
                                                        <c:choose>
                                                        <c:when test="${schedatest.rows[0].superato == 'true'}" >
                                                        <td align="center" bgcolor="white"> Positivo </td>
                                                        </c:when>
                                                        <c:otherwise>
                                                        <td align="center" bgcolor="white"> Negativo </td>
                                                        </c:otherwise>
                                                       </c:choose>
                                                </tr>
                                            </c:if>
                                        </table>
                                    </td>
                                </tr>
                                <tr height="40%">
                                    <td>
<%---------------------------------------------------------------------------------%>
<%-----------------------   TASTO PER VISUALIZZARE SCHEDA PRODOTTO ----------------%>
<%---------------------------------------------------------------------------------%>

                                        <table width="90%" height="100%"  border="0" cellspadding="5">
                                            <tr width="100%" height="100%">
                                                <td width="30%" height="100%" valign="top" align="center">
                                                    <form method="post" action="scheda_test.jsp">
                                                        <input type="submit" name="visualizza" value="Visualizza scheda prodotto" style="background:#008080;color:white">
                                                        <input type="hidden" name="id_scheda" value="${schedatest.rows[0].id_scheda}"/>
                                                        <input type="hidden"  name="id_test" value="${schedatest.rows[0].id_test}"> 

                                                    </form>
                                                </td>
                                                <td width="90%" height="100%">
													<c:if test="${not empty param.visualizza}">
												<table>
														<tr>
															<form method="post" action"scheda_test.jsp">
                                                               <td valign="top" align="right">
                                                                 <input type="image" name="submit" style="width:20px;height:20px" src="rosso1.png"/>
                                                                 <input type="hidden"  name="id_test" value="${schedatest.rows[0].id_test}"> 
                                                                </td>
                                                            </form>
														</tr>
														<tr>
															<td>
                                                                <table width="90%" height="50%" border="1" cellpadding="8" cellspacing="0"  bordercolor="#008080" bgcolor="#a5bacd" align="right">
                                                                   <tr style="margin-right:8px;">                                                             
                                                                      <td align="left" bgcolor="#a5bacd" height="10%" width="40%">
                                                                       </td>
                                                                        <td width="60%">
                                                                           <font size="3"> SCHEDA PRODOTTO:&nbsp ${param.id_scheda}</font>
                                                                        </td 
                                                                   </tr>
                                                                    <tr width="100%" height="30%">
                                                                          <td align="left" bgcolor="#a5bacd" height="15%" style="padding-right:10px"> 
                                                                          Nome:  &nbsp${prod.rows[0].Nome_prod} 
                                                                          </td> 
                                                                          <td align="left" bgcolor="#a5bacd" height="15%" style="padding-right:10px" width="60%"> 
                                                                           Uso:  &nbsp${prod.rows[0].uso} 
                                                                          </td> 
                                                                     </tr>
                                                                    <tr width="100%" height="30%">
                                                                        <td align="left" bgcolor="#a5bacd" height="10%" style="padding-right:10px"> 
                                                                        CPR:  &nbsp${prod.rows[0].nome} 
                                                                        </td> 
                                                                        <td align="left" bgcolor="#a5bacd" height="20%" style="padding-right:10px" width="60%"> 
                                                                        Materiali: &nbsp ${prod.rows[0].materiali} 
                                                                        </td> 
                                                                    </tr>
                                                                    <tr width="100%" height="30%">
                                                                        <td align="left" bgcolor="#a5bacd" height="20%" style="padding-right:10px"> 
                                                                         Tipo:  &nbsp${prod.rows[0].tipo}
                                                                        </td> 
                                                                        <td align="left" bgcolor="#a5bacd" height="20%" style="padding-right:10px" width="60%"> 
                                                                        Beneficio:  &nbsp${prod.rows[0].beneficio} 
                                                                        </td> 
                                                                    </tr>
                                                                 </table>
                                                            </td>
                                                       </tr>
                                                       </table>
                                                   </c:if>
												</td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
<%---------------------------------------------------------------------------%>
<%-----------------------      SEZIONE DX                     ---------------%>
<%---------------------------------------------------------------------------%>

                        <td width="35%" style="padding: 0px; border-left-width: 12px; border-right-width: 3px">
                            <table  cellspacing="0"width="100%" height="100%"  border="0" bgcolor="#a5bacd">
                                <tr >
                                        <form method="post" action="rapporto.jsp">
                                            <td width="60%" align="right">
                                                     <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif, sans-serif;font-weight: bold; font-style: italic;margin-bottom:2px" >RAPPORTO</p>
                                                     <hr  color="#53667a" size="9px">
                                                <c:if test="${empty schedatest.rows[0].data_ora_esito}">
                                                      <p style="font-size:15px;color: white; font-weight: bold;font-family:arial;margin-top:14px" >Compila rapporto</p>
                                                </c:if>
                                                <c:if test="${not empty schedatest.rows[0].data_ora_esito}">
                                                      <p style="font-size:15px;color: white; font-weight: bold;font-family:arial;margin-top:14px" >Visualizza rapporto </p>
                                                </c:if>
                                            </td>                                                  
                                            <td width="40%"  align="center"><button  style="border-color:   #a5bacd;background-color:  #a5bacd;"><img style="width:90px;height:90px;"src="rapporto.jpg"></button>
                                                 <input type="hidden"  name="id_test" value="${schedatest.rows[0].id_test}">
                                                 <input type="hidden"  name="rapporto" value="${schedatest.rows[0].rapporto}">
                                                 <input type="hidden"  name="data_ora_esito" value="${schedatest.rows[0].data_ora_esito}">
                                                 <input type="hidden"  name="esito" value="${schedatest.rows[0].superato}">
                                                 <input type="hidden"  name="n_mess1" value="${n_mess1}"/>
                                            </td>
                                        </form>
                                </tr>
                                <tr>
<%------------------------------------------------------------------------------------------------------------------------------------------------------------%>
<%------------SE IL NUMERO DI MESSAGGI E' MAGGIORE DI 0 ALLORA APRI LA PAGINA CON I MESSAGGI ALTRIMENTI QUELLA PER INIZIARE UNA NUOVA COVERSAZIONE------------%>
<%------------------------------------------------------------------------------------------------------------------------------------------------------------%>

                                <c:if test="${n_mess1 > 0 && (not empty schedatest.rows[0].data_ora_esito || empty schedatest.rows[0].data_ora_esito)}">
                                     <form method="post" action="messaggi.jsp">
                                        <td width="60%" align="right">
                                           <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px">                                               
                                                <c:if test="${n_mess>0}">
                                                    <font color="green" size="2">
                                                        <b>${n_mess}</b>
                                                    </font>
                                                <img style="width:30px;height:30px;" src="0.png">
                                                </c:if>MESSAGGI</p>
                                               <hr color="#53667a" size="9px">
                                           <p style="font-size:15px;color:  white;font-weight: bold; font-family:arial;margin-top:14px" >Visualizza messaggi</p>
                                        </td>
                                        <td width="40%"  align="center">
                                            <button  style="border-color: #a5bacd;background-color:   #a5bacd;">
                                                <img style="width:90px;height:90px;"src="newtext.jpg">
                                            </button>
                                            <input type="hidden"  name="id_test" value="${schedatest.rows[0].id_test}"/>
                                            <input type="hidden"  name="nome" value="${schedatest.rows[0].nome}"/>
                                            <input type="hidden"  name="n_mess1" value="${n_mess1}"/>
                                        </td> 
                                    </form>
                                </c:if>
                                <c:if test="${n_mess1 == '0' && not empty schedatest.rows[0].data_ora_esito}">
                                    <td width="60%" align="right">
                                        <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px">MESSAGGI</p>
                                        <hr color="#53667a" size="9px">
                  
                                        <p style="font-size:17px;color:  white;font-weight: bold; font-family:arial;margin-top:14px" >Non sono stati scambiati messaggi</p>
                                    </td>
                                    <td width="40%"  align="center"><img style="width:90px;height:90px;"src="newtext.jpg"></td> 
                                                                   
                                </c:if>
                                <c:if test="${n_mess1 == '0' && empty schedatest.rows[0].data_ora_esito}">
                                    <form method="post" action="chat1.jsp">
                                       <td width="60%" align="right">
                                           <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px">MESSAGGI</p>
                                           <hr color="#53667a" size="9px">
                        
                                           <p style="font-size:15px;color:  white;font-weight: bold; font-family:arial;margin-top:14px" >Avvia nuova conversazione</p>
                                       </td>
                                       <td width="40%"  align="center">
                                        <button  style="border-color: #a5bacd;background-color:   #a5bacd;">
                                       <img style="width:90px;height:90px;"src="newtext.jpg">
                                       </button>
                                       <input type="hidden"  name="id_test" value="${schedatest.rows[0].id_test}">
                                       <input type="hidden"  name="nome" value="${schedatest.rows[0].nome}">
                                       <input type="hidden"  name="n_mess1" value="${n_mess1}"></td> 
                                     </form>
                                </c:if>
                                  </tr>
                            </table>
                        </td>
                </tr>
        </TABLE>
<%@ include file="bottom.jspf"%>


 