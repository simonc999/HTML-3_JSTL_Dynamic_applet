<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>


<%@ include file="top.jspf"%>
<form method="post" action="gov_prodotti.jsp" >

     <td align="right"width="60" >
        <!-- COMANDO INDIETRO -->
        <button style="border-color:#007171;background-color:#007171"><img style="width:60px;height:60px" src="back.jpeg"></button></td></form>





<%@ include file="middle.jspf"%>

<sql:query var="info_test">
    select t.id_test, tt.tipo, p.Nome_prod, t.data_ora, t.scopo, t.risultati_attesi, t.descrizione, t.rapporto, p.Id_scheda
    from TEST t, SCHEDA_PROD p, TIPO_TEST tt
    where p.id_scheda = t.id_scheda and tt.id_tipo = t.id_tipo  and id_test  LIKE ? 
    <sql:param value="${param.id_scheda}"/>
</sql:query>
<br>
             <TABLE  cellspacing="0" border="0" bgcolor="#bbccdc"
                 width="100%" height="100%" bordercolor="#41140E"  >


 <tr><td align="center" width="100%" style="font-family:arial"> <p style="font-size:23px;font-weight:bold;color: #007171;">In questa sezione sara' possibile visualizzare il rapporto dei certificatori per il prodotto selezionato.</p>
    </td>
</tr>

                                   <tr width="80%">
                                      <td  width="100%" align="center" style="font-size:18px; font-family:arial">
                                          <table width="90%" border="1" cellspacing="0" cellpadding="3" bordercolor="bbccdc"> 
                                            <tr>
                                                <td align="left" width="20%" height="22%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial" size="3">CODICE: </font></td>
                                                <td align="center" bgcolor="white"> ${info_test.rows[0].id_test} </td>
                                            </tr>

                                            <tr>
                                                <td align="left" width="20%" height="35%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial" size="3">TEST: </font></td>
                                                <td align="center" height="35%" bgcolor="white"> ${info_test.rows[0].tipo} </td>
                                            </tr>
                                            
                                            <tr>
                                                <td align="left" width="20%" height="22%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial" size="3">PRODOTTO: </font></td>
                                                <td align="center"bgcolor="white"> ${info_test.rows[0].Nome_prod} </td>
                                            </tr>
                                            
                                            
                                            <tr>
                                                <td align="left" width="20%" height="35%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial" size="3">DATA E ORA: </font></td>
                                                <td align="center" height="35%" bgcolor="white"> ${info_test.rows[0].data_ora} </td>
                                            </tr>
                                            
                                            <tr>
                                                <td align="left" width="20%" height="22%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial" size="3">SCOPO</font></td>
                                                <td align="center" bgcolor="white"> ${info_test.rows[0].scopo} </td>
                                            </tr>
                                            
                                            <tr>
                                                <td align="left" width="20%" height="22%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial" size="3">RISULTATI ATTESI: </font></td>
                                                <td align="center" bgcolor="white"> ${info_test.rows[0].risultati_attesi} </td>
                                            </tr>

                                            <tr>
                                                <td align="left" width="20%" height="22%" bgcolor="#007171">
                                                <font color="#9ad6d6" face="Arial" size="3">ESITO: </font></td>
                                                <td align="center" bgcolor="white"> ${info_test.rows[0].descrizione} </td>
                                            </tr>

                                         

 <br>                                
<table><tr><p style="font-size:32px;color:#3b4957; font-family:Arial, Helvetica, sans-serif;font-weight: bold; font-style: italic;margin-bottom:5px"><br>RAPPORTO</p></tr>
  
<TEXTAREA NAME="NOTE" ROWS="15" COLS="50">${info_test.rows[0].rapporto}</TEXTAREA>

 </table>                                                
          </TABLE>


<br>






<%@ include file="bottom.jspf"%>