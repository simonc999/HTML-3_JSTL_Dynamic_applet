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

<td align="right" width="60">
        <!-- COMANDO INDIETRO -->
       <a href="home_cpr.jsp"> 
            <img style="width:60px;height:60px" src="indietro.png">
       </a>
     </td>

<%@ include file="middle.jspf"%>
<form method="post" action="#">
  <TABLE border="0" align="center" width="100%" height="100%">
     <tr height="25%">
       <td align="center">
       <h1><font color="008080">POSTA LAB</font> </h1> 
       <h3>Area di messaggistica: scambia messaggi con le CPR </h3> 
       <a href="chat.jsp"><font color="008080"> + NUOVO MESSAGGIO &nbsp &nbsp
       <img src="invia.png" title="crea messaggio" width="25"> </font> </a>
       <br/>
       </td>  
     </tr>
          
   <tr>
       <td valign="top">
          <TABLE border="0" align="center" width="100%" height="100%">
    <tr>
       <td width="60%" height="100%">
           <table border="0"  width="100%" height="100%">
            <tr height="100%">
            <td width="65%" height="100%">
                <table border="0"  width="100%" height="100%">
                   <tr>
                   <td valign="top">

   <table cellspacing="0" cellpadding="1" border="1" bgcolor="007171" width="800">
      <tr bgcolor="#008080">
          <th WIDTH="20%"><font color="9ad6d6"  align="center" >MITTENTE</font></th>
          <th WIDTH="35%"><font color="9ad6d6"  align="center"> OGGETTO</font></th>
          <th WIDTH="15%"><font color="9ad6d6"   align="center">DATA</font></th>
          <th WIDTH="10%"><font color="9ad6d6"   align="center">TIPO</font></th>
          <th WIDTH="20%"><font color="9ad6d6"  align="center" >VISUALIZZA</font></th>
      </tr>
    </table><br/>
                    </td>
                    </tr>
                    <tr >
                    <td valign="top">

<div style="width:850px; height:270px; overflow:auto;">
  <table border="1" width="800px"   bgcolor="white" >
    <c:forEach var="i" begin="1" end="30">
      <form method="post" action="posta_lab.jsp" >
        <tr>
         <td WIDTH="20%"> ${param.nome_lab} param.nome_lab</td>
         <td WIDTH="35%"> ${param.oggetto} ${i} param.oggetto/codice_scheda</td>
         <td WIDTH="15%"> ${param.data} param.data/ora</td>
         <td WIDTH="10%"> <IMG SRC="posta_invia.png" width="25" title="messaggio inviato"> 
          &nbsp
         <IMG SRC="posta_ricevi.png" width="25" title="messaggio ricevuto">
         </td>
         <td align="center" WIDTH="20%" valign="top" >
         <input type="submit" value="visualizza messaggio"/></td>
        </tr>
      </form>  
    </c:forEach>
  </table>
</div>
                      </td>
                      </tr>                                                  	
                  </table>
                                                
               </td>
              </tr>
          </table>
         </td>
         <td>
         <table width="100%" height="100%" border="1" cellpadding="1" bordercolor="bbccdc" 
          bgcolor="a5bacd">
         <tr><td> visualizza messaggio</td></tr>
         </table>
                               </td>
                            </tr>
                        </table>
                      </td>
              </tr>
           </TABLE>

<input type="hidden" name="messaggio_lab" value="${param.messaggio_lab}">
<input type="hidden" name= "nome_lab" value="${param.nome_lab}"
<input type="hidden" name="oggetto" value="${param.oggetto}">
<input type="hidden" name="data" value="${param.data}">
</form>
<%@ include file="bottom.jspf"%>


