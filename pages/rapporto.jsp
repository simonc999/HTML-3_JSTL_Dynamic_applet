<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>
<%---------------------------------------------------------------------------%>
<%-----------------------      AUTORIZZAZIONE AREA LAB        ---------------%>
<%---------------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="4"/>
<c:set var="auth_page" value="home_lab.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Laboratorio"/>

<%@ include file="auth.jspf"%>


<%@ include file="top.jspf"%>
  <form method="post" action="scheda_test.jsp"> 

            <td align="right" width="60">
                    <!-- COMANDO INDIETRO -->
                   
                   <input type="hidden" name="id_test" value="${param.id_test}"/>
                   <input type="hidden" name="presc" value="${param.test}"/>
                <input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
            </td> 
    </form>

<%@ include file="middle.jspf"%>

<%---------------------------------------------------------------------------%>
<%-----------------------      QUERY PER SELEZIONARE PARAMETRI DALLE TABELLE        ---------------%>
<%---------------------------------------------------------------------------%>
<sql:query var="rapporto">
    select t.id_test, tt.descrizione, tt.tipo, c.data_pagamento
    from TEST t, TIPO_TEST tt, CANDIDATURA c
    where t.id_tipo=tt.id_tipo and c.id_test=t.id_test and c.data_pagamento is not null and t.id_test="${param.id_test}"
</sql:query>
<%--
<sql:query var="data_mex">
select max(m.data_ora) as data_ora
from MESSAGGI m
where m.user_lab="${user_userid}" and m.id_test="${param.id_test}"
</sql:query>
--%>

<%---------------------------------------------------------------------------%>
<%-----------------------      FORMATTAZIONE DATE       ---------------%>
<%---------------------------------------------------------------------------%>
<fmt:formatDate var="var_data" 
                value="${rapporto.rows[0].data_pagamento}"
                pattern="yyyy-MM-dd"/>

<fmt:formatDate var="var_ora"
                value="${rapporto.rows[0].data_pagamento}"
                type="time"
                pattern="HH:mm"/>


<TABLE  cellspacing="0" border="0" bgcolor="#bbccdc"
          width="100%" height="100%" bordercolor="#41140E"  >
<%---------------------------------------------------------------------------%>
<%-----------------------      SEZIONE SX        ---------------%>
<%---------------------------------------------------------------------------%>
  <form method="post" action="inoltra_rapporto.jsp">
    <td align="left" width="70%"  style="padding: 0px;border-left-width: 3px ">
        <table border="0" width="100%" height="100%">
            <tr width="100%">
               <td width="100%" height="15%" valign="top"><br> 
                  <p align="center" style="font-size:35px;font-weight:bold;color: #007171;">RAPPORTO CONCLUSIVO</p>
                  <p align="center" valign="top"><font color="black" style="font-size:15px;font-weight:bold;font-family:arial">Di seguito il rapporto sul <font color="#008080" style="font-size:15px;font-weight:bold;font-family:arial"> ${param.id_test}</font></font></p>
                 </td>
               </tr>
<%--------------------CHOOSE: SE IL RAPPORTO NON E' ANCORA STATO EFFETTUATO PROCEDO CON LA COMPILAZIONE--------------------%>

<c:choose>
<c:when test="${empty param.rapporto}" >
           
              <tr height="70%" width="100%">
              <td>
              <table border="0" width="100%">
                  <tr align="left" valign="top">
                      <td valign="top" align="center">
                      <p align="center" style="font-size:20px;font-weight:bold;color: #007171;">Area di compilazione</p>
                      <TEXTAREA NAME="Note" ROWS="15" COLS="50" paceholder="Note" value="${param.Note}">${param.Note}</TEXTAREA>
                      </td> 
                  </tr>
              </table>
              </td>                                     
              </tr>
              <tr height="15%" width="100%">
               <td >&nbsp;</td>
              </tr>
        </table>
    </td>
        <!-- SEZIONE PRINCIPALE DX  -->
        <td width="30%" style="padding: 0px; border-left-width: 12px; border-right-width: 3px">
           <table  cellspacing="0" border="0" width="100%" height="100%" bgcolor="#a5bacd">
            <tr>
                <td>
                    <table border="0" height="100%">
                        <tr height="18%">
                            <td width="60%" align="left" valign="bottom">
                                <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px">DATI TEST</p>
                                <hr color="#53667a" size="9px"/>
                                 <tr height="10%" width="100%">
                                    <td align ="center">
                                       <p align="center">
                                         <c:if test="${not empty errmsg}">
                                          <font color="red" >${errmsg}</font>
                                         </c:if>
                                       </p>
                                     </td>
                                 </tr>
                            </td>
                        </tr>
                        <tr valign="top">
                            <td  valign="top" width="60%" style="font-family:arial;padding: 12px; border-left-width: 12px; border-right-width: 3px;">
                                <p style="font-size:17px;font-weight:bold;color: #007171;">Data e ora</p>

   <input name="date" type="date" min="${var_data}" value="${param.date}">
   <input name="time" type="time" value="${param.time}">

                                <p style="font-size:15px;font-weight:bold;color: #007171;">Test:&nbsp<font color="black" style="font-weight:normal;" >${rapporto.rows[0].id_test}</font></p>
                                <p style="font-size:15px;font-weight:bold;color: #007171;">Tipo Test:&nbsp<font color="black" style="font-weight:normal;">${rapporto.rows[0].tipo}</font></p>
                                <p style="font-size:15px;font-weight:bold;color: #007171;">Descrizione:&nbsp<font color="black" style="font-weight:normal;" >${rapporto.rows[0].descrizione}</font></p>
                                <p style="font-size:15px;font-weight:bold;color: #007171;">Esito<br> </p>
                                <input type="radio" name="esito" value="1"> Superato
                                <br>
                                <input type="radio" name="esito" value="0"> Non superato
                              </td>
                        </tr>
                        <tr>
                            <td align="center">
                            <input type="submit" name="termina" value="Invia tutto e termina" style="background:#008080;color:white">
                            <input type="hidden" name="id_test" value="${rapporto.rows[0].id_test}"/>
                            <input type="hidden" name="id_test" value="${user_userid}"/>
                            <input type="hidden"  name="var_data" value="${var_data}"/>
                            <input type="hidden"  name="var_data1" value="${var_data1}"/>
                            <input type="hidden"  name="var_ora" value="${var_ora}"/>
                            </td>
                        </tr>
                    </table>
                </td> 
            </tr>
</c:when>
<%-----------------OTHERWISE: SE IL TEST E' STATO EFFETTUATO NE VISUALIZZO IL RAPPORTO GIA' COMPILATO-----------%>
<c:otherwise>
           
              <tr height="70%" width="100%">
              <td align="center">
              
              <table border="1" width="50%" height="50%">
                  <tr align="left" valign="top">
                      <td valign="top" bgcolor="white" width="50%" height="50%">
                      <p><font color="black" style="font-weight:normal;" >${param.rapporto}</font></p>
                      
                      </td> 
                  </tr>
              </table>
              </td>                                     
              </tr>
              <tr height="15%" width="100%">
               <td >&nbsp;</td>
              </tr>
        </table>
    </td>
<%---------------------------------------------------------------------------%>
<%-----------------------      SEZIONE DX        ---------------%>
<%---------------------------------------------------------------------------%>
        <td width="30%" style="padding: 0px; border-left-width: 12px; border-right-width: 3px">
           <table  cellspacing="0" border="0" width="100%" height="100%" bgcolor="#a5bacd">
            <tr>
                <td>
                    <table border="0" height="100%">
                        <tr height="18%">
                            <td width="60%" align="left" valign="bottom">
                                <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px">DATI TEST</p>
                                <hr color="#53667a" size="9px"/>
                                 <tr height="10%" width="100%">
                                    <td align ="center">
                                       <p align="center">
                                         <c:if test="${not empty errmsg}">
                                          <font color="red" >${errmsg}</font>
                                         </c:if>
                                       </p>
                                     </td>
                                 </tr>
                            </td>
                        </tr>
                        <tr valign="top">
                            <td  valign="top" width="60%" style="font-family:arial;padding: 12px; border-left-width: 12px; border-right-width: 3px;">
                                <br><p style="font-size:17px;font-weight:bold;color: #007171;">Data e ora:&nbsp<font color="black" style="font-weight:normal;font-size:14px" >${param.data_ora_esito}</font></p><br>
                                <p style="font-size:15px;font-weight:bold;color: #007171;">Tipo Test:&nbsp<font color="black" style="font-weight:normal;">${rapporto.rows[0].tipo}</font></p><br>
                                <p style="font-size:15px;font-weight:bold;color: #007171;">Descrizione:&nbsp<font color="black" style="font-weight:normal;" >${rapporto.rows[0].descrizione}</font></p><br>
                                <p style="font-size:15px;font-weight:bold;color: #007171;">Esito:&nbsp
                                    <c:choose>
                                      <c:when test="${schedatest.rows[0].superato == 'true'}" >
                                         <font color="black" style="font-weight:normal;">Positivo</font></p>                                                                     
                                      </c:when>
                                      <c:otherwise>
                                         <font color="black" style="font-weight:normal;">Positivo</font> </p>
                                      </c:otherwise>
                                     </c:choose> 
                                
                              </td>
                        </tr>
                   </table>
                </td>
</c:otherwise>
</c:choose> 
            </tr>
           </table>
        </td>
        </form>
</TABLE>
<%@ include file="bottom.jspf"%>
