<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>


<c:set var="auth_cod_ruolo" value="4"/>
<c:set var="auth_page" value="home_lab.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Laboratorio"/>

<%@ include file="auth.jspf"%>


<%@ include file="top.jspf"%>

 <td width="60" align="center">
          <!-- COMANDO LOGOUT -->
       <a href="home_lab.jsp"> 
            <img style="width:60px;height:60px" src="indietro.png">
       </a>
     </td>
       
<%@ include file="middle.jspf"%>




<%------ESTRAZIONE DALLA QUERY DELLA DESCRIZIONE DI UN TEST PER OGNI TIPO ----%> 
 
<sql:query var="tipo_test">
select descrizione, tipo,
costo_min,
costo_max,
id_tipo
from TIPO_TEST 
where id_tipo =?
<sql:param value="${param.tipotest}"/>
</sql:query>



<%------QUERY PER PRENDERE I VALORI DEI TIPI TEST ----%>


<sql:query var="rset_testeffettuabili">
    select l.prezzo, tt.tipo, tt.descrizione, l.user_lab,tt.id_tipo
    from AVERE_LISTINO l, TIPO_TEST tt
    where l.id_tipo=tt.id_tipo and l.user_lab="${user_userid}"
</sql:query>

<sql:query var="listino">
    select tipo, id_tipo, descrizione
    from TIPO_TEST
    where id_tipo not in (select id_tipo from AVERE_LISTINO where user_lab="${user_userid}")
</sql:query>





<TABLE align="center" border="0" height="100%" width="100%" cellpadding="5">
      <tr>
         <%----------------------------%>
         <%-- SEZIONE PRINCIPALE SX  --%>
         <%----------------------------%>

        <td width="65%" > 
            <table border="0" align="right" height="90%">
               <tr>
                 <td ><h1 align="center" valign="middle"><font color="#008080">LISTINO PREZZI </font></h1>
                       <p><font>In questa sezione e' possibile vedere il listino prezzi dei test che il laboratorio e' in grado di svolgere.<br> <br></font></p> 
                 </td>

               </tr>
               <tr>
                  <td>
                      <c:if test="${not empty ciao}">
                      <font color="green" size="4"> ${ciao} </font>
                      </c:if>
                                
                       <%-- TABELLA LISTINO PREZZI --%>
                     <table cellspacing="0" cellpadding="1" border="1" width="800">
                          <tr bgcolor="#008080">
                              <th width="25%"><font color="#bfebfc">CODICE</font></th>
                              <th width="25%"><font color="#bfebfc">TIPO</font></th>
                              <th width="25%"><font color="#bfebfc">DESCRIZIONE</font></th>
                              <th width="25%"><font color="#bfebfc">TARIFFA</font></th>
                          </tr>
                     </table>
                    <br>
                  </td>
                </tr>
               <tr>
                  <td>
                     <div style="width:850; height:250px; overflow:auto;">
                       <table cellspacing="0" cellpadding="1" border="1" width="800" >
                             <c:forEach items="${rset_testeffettuabili.rows}" var="row">
                               
                                <tr bgcolor="#eeeeee" height="20">
                                    <td width="25%" align="center"><c:out value="${row.id_tipo}"/></td>
                                    <td width="25%"><c:out value="${row.tipo}"/></td>
                                    <td width="25%"><c:out value="${row.descrizione}"/></td>                                    
                                    <td width="25%"><c:out value="${row.prezzo}"/>&euro;</td>
                                </tr>
                                
                             </c:forEach>
                         </table>  
                       </div>
                      </td>
                    </tr>
            </table>
         </td>
         <td height="100%" width="35%" bgcolor="#a5bacd">

         <%----------------------------%>
         <%-- SEZIONE PRINCIPALE SX  --%>
         <%----------------------------%>

            <table border="0" width="90%" height="90%" align="center">
                <form method="post" action="listino.jsp">
                  <tr height="25%">
                            <td width="60%" align="left" valign="center">
                                <p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px">CREAZIONE NUOVO TEST</p>
                                <hr color="#53667a" size="9px"/>
<font color="white" style="font-size:20px;">Aggiungi un nuovo test al tuo listino</font>
                            </td>
                        </tr>   
                    <tr width="100%" valign="top" align="center" height="10%">
                        <td>


                                <%-- SELECT CON CUI SELEZIONO IL TIPO TEST DI CUI VOGLIO FARE IL LISTINO  --%>



                           <SELECT style="width:220px; height:22px;" NAME="tipotest" onchange="this.form.submit()">
                                <OPTION VALUE="" <c:if test="${not empty ciao}">selected</c:if>>Nessuno</OPTION>
                                 <c:forEach items="${listino.rows}" var="row">
                                    <OPTION VALUE="${row.id_tipo}" 
                                      <c:if test="${row.id_tipo==param.tipotest}">selected="selected"</c:if>
                                      >${row.descrizione}</OPTION>
                                 </c:forEach>
                            </SELECT>
                        </td>
                    </tr>
                </form>
                                 <tr height="10%" width="100%">
                                    <td align ="center">
                                       <p align="center">
                                         <c:if test="${not empty errmsg}">
                                          <font color="red" >${errmsg}</font>
                                         </c:if>
                                       </p>
                                     </td>
                                 </tr>
                <tr valign="top">
                    <td valign="top">
                    <c:if test="${not empty param.tipotest && empty ciao}">
                            <table border="1" width="100%" height="90%" align="center" cellspacing="0" bordercolor="#008080">
                         

                           <%-- FORM PER CREARE UN NUOVO LISTINO  --%>


                            <form method="post" action="aggiungi_listino.jsp">
                                
                                <tr>
                                    <td>
                                    <font color="black" style="font-size:19px;">TIPO:&nbsp
                                    ${tipo_test.rows[0].tipo} </font></td>
                                </tr>
                                <tr>
                                    <td>
                                    <font color="black" style="font-size:19px;">DESCRIZIONE:&nbsp
                                    ${tipo_test.rows[0].descrizione} </font></td>
                                </tr>
                                <tr>
                                    <td>
                                    <font color="black" style="font-size:19px;">La tariffa suggerita e' compresa tra ${tipo_test.rows[0].costo_min} e ${tipo_test.rows[0].costo_max} &euro; </font> 
                                    </td>
                               </tr>
                                <tr>
                                    <td>
                                     <font color="black" style="font-size:19px;">Inserisci tariffa &nbsp
                                      <input type="text"  name="costo" value="${param.costo}"/><br><br><font color="green" style="font-size:16px;"> *Si ricorda che la parte decimale va separata con la virgola [###,##]*</font></font></td>
                                </tr>
                                <tr>     
                                    <td align="center">
                                        <input type="hidden" name="tipotest" value="${tipo_test.rows[0].id_tipo}"/>
                                         <input type="hidden" name="costo" value="${param.costo}"/>
                                         <input type="hidden" name="costo_min" value="${tipo_test.rows[0].costo_min}"/> 
                                         <input type="hidden" name="costo_max" value="${tipo_test.rows[0].costo_max}"/>
                                        
                                        <input type="submit" name="aggiungi" value="aggiungi" style="width:70px;background:#a5bacd"/>
                                    </td>
                                </tr>
                             </form> 
                          </table>
                    </c:if>
                    </td>
                </tr>
            </table>
         </td>
      </tr>     
 </TABLE>
<%@ include file="bottom.jspf"%>

 