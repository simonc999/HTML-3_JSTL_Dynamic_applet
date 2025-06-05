<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>


<%----- FRAMMENTO AUTH ------%>
<c:set var="auth_cod_ruolo" value="3"/>
<c:set var="auth_page" value="home_cert.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Certificatore"/>

<%@ include file="auth.jspf"%>


<%@ include file="top.jspf"%>

 <form method="post" action="info_test.jsp"> 

            <td align="right" width="60" >
                    <!-- COMANDO INDIETRO -->
                   <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
                   <input type="hidden" name="id_test" value="${param.id_test}"/>
                   <input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
            </td> 
    </form>

<%@ include file="middle.jspf"%>
<%--------------------------------------------------------------------------%>
<%-- QUERY CHE ESTRAE I MESSAGGI SCAMBIATI TRA IL LAB E IL CERT PER UN
     DETERMINATO TEST --%>
<%--------------------------------------------------------------------------%>
<sql:query var="rset_mex_cert">
    select m.data_ora, m.oggetto, m.testo, c.nome , m.inviato, p.Nome_prod,   
           m.id_messaggio, m.user_lab
    from MESSAGGI m, TEST t, SCHEDA_PROD p, CPR c
    where t.id_test=m.id_test 
      and c.user_cpr=p.user_cpr 
      and t.id_scheda = p.id_scheda
      and t.id_test="${param.id_test}"
</sql:query>

<%--------------------------------------------------------------------------%>
<%-- QUERY CHE ESTRAE IL NOME DEL LAB                                     --%>
<%--------------------------------------------------------------------------%>
<sql:query var="nomelab">
    select l.nome
    from LAB l 
    where l.user_lab="${rset_mex_cert.rows[0].user_lab}"
</sql:query>



<TABLE border="0" align="center" width="100%" height="100%">
                  <tr height="5%"><td><c:if test="${not empty mess_inviato}">
<font color="green">${mess_inviato}</font>
</c:if></td></tr>
<c:choose>
<%--------------------------------------------------------------------------%>
<%-- C:WHEN QUANDO NON SONO PRESENTI MESSAGGI  --%>
<%--------------------------------------------------------------------------%>
<c:when test="${rset_mex_cert.rowCount == 0}">
  <tr height="30%">
  <td align="center" >
     <h1><font color="008080">POSTA</font> </h1> 
     <h3>Area di messaggistica: visualizza i messaggi scambiati tra laboratori e CPR </h3> 
     <br/>
  </td>
  </tr>

  <tr height="70%">
  <td align="center">
      <br/>
      <p>Non ci sono messaggi riguardanti il test scelto!</p>
      <br/>
  </td>
  </tr>
</c:when>
<c:otherwise>
<%--------------------------------------------------------------------------%>
<%-- C:OTHERWISE QUANDO INVECE SONO PRESENTI DEI MESSAGGI                 --%>
<%--------------------------------------------------------------------------%>
  <tr height="20%" valign="top">
  <td align="center" >
      <h1><font color="008080">POSTA</font> </h1> 
      <h3>Area di messaggistica: visualizza i messaggi scambiati tra il laboratorio   
          ${nomelab.rows[0].nome} e  la casa produttrice
          ${rset_mex_cert.rows[0].nome} riguardo al ${param.id_test}</h3> 
          <br/>
  </td>
  </tr>


   <tr>
   <td>
        <TABLE border="0" align="center" width="100%" height="100%">
         <tr>
         <td width="60%" height="100%">
         <table border="0"  width="100%" height="100%">
         <tr height="100%">
         <td width="65%" height="100%">
         <table border="0"  width="100%" height="100%">
         <tr >
         <td valign="top">

<%--------------------------------------------------------------------------%>
<%-- INTESTAZIONE                                                         --%>
<%--------------------------------------------------------------------------%>
         <table cellspacing="0" cellpadding="1" border="1" bgcolor="007171" 
          width="800">
             <tr bgcolor="#008080">
             <th WIDTH="25%"><font color="9ad6d6" align="center"> MITTENTE </font> </th>
             <th WIDTH="35%"><font color="9ad6d6" align="center"> OGGETTO  </font> </th>
             <th WIDTH="15%"><font color="9ad6d6" align="center"> DATA     </font> </th>
             <th WIDTH="20%"><font color="9ad6d6" align="center">VISUALIZZA</font> </th>
             </tr>
         </table><br/>
         </td>
         </tr>
         <tr >
         <td valign="top">

<%--------------------------------------------------------------------------%>
<%-- TABELLA CON TUTTI I MESSAGGI, CON C:FOREACH ALL'INTERNO CHE ESTRAE TUTTI 
     I DATI DELLA QUERY (rset_mex_cert), CHE ESTRAE TUTTI I MESSAGGI      --%>                        
<%--------------------------------------------------------------------------%>
         <div style="width:850px; height:270px; overflow:auto;">
        
         <table border="1" width="800px"   bgcolor="white" >
            <c:forEach items ="${rset_mex_cert.rows}" var= "mex"> 
            <form method="post" action="#">
         <tr>
             <c:if test="${mex.inviato}">
               <td align="center" WIDTH="25%">${nomelab.rows[0].nome}</td>
               <input type="hidden" name="mittente" value="${nomelab.rows[0].nome}"/>
             </c:if>  
            <c:if test="${not mex.inviato}">
               <td align="center" WIDTH="25%">${mex.nome}</td>
               <input type="hidden" name="mittente" value="${mex.nome}"/>
             </c:if>
           <td WIDTH="35%"><c:out value="${mex.oggetto}"/>                 </td>
           <td WIDTH="15%"> <c:out value="${mex.data_ora}"/>               </td>
           <td align="center" valign="middle" WIDTH="20%" valign="top" >
           <input type="submit" value="visualizza messaggio" name="visualizza"/>
                 <input type="hidden" name="id_scheda" value="${param.id_scheda}"/> 
                 <input type="hidden" name="id_test" value="${param.id_test}"/>
                 <input type="hidden" name="data" value="${mex.data_ora}"/>
                 <input type="hidden" name="oggetto" value="${mex.oggetto}"/>
                 <input type="hidden" name="testo" value="${mex.testo}"/>
                
           </td>
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
<%--------------------------------------------------------------------------%>
<%-- TABELLA CHE MI PERMETTE DI VEDERE I DETTAGLI DEL MESSAGGIO CHE VOGLIO 
     VISUALIZZARE QUANDO CLICCO IL SUBMIT (visualizza messaggio)          --%>                        
<%--------------------------------------------------------------------------%>
        <c:if test="${not empty param.visualizza}">
        
            <table border="0" width="70%" height="80%" align="center">
             <tr height="5%">
              <form method="post" action="messaggi1.jsp">
                 <td valign="top" align="right">
                     <input type="image" name="submit" style="width:20px;height:20px" src="rosso1.png"/>
                     <input type="hidden"  name="id_test" value="${param.id_test}"> 
                     <input type="hidden"  name="nome" value="${param.nome}"> 
                 </td>
              </form>
             </tr>
             <tr>
             <td>
             <table width="100%" height="100%" border="1" cellpadding="0" bordercolor="black" bgcolor="bbccdc">
               <tr>
                 <td align="right" bgcolor="#ADD8E6" height="10%">
                    <font size="2"> ${param.data}</font>
                 </td>
              </tr>
              <tr>
                 <td align="left" bgcolor="#ADD8E6" height="20%" > 
                    Mittente:  ${param.nome} 
                 </td> 
              </tr>
              <tr>
                 <td align="left" bgcolor="#ADD8E6" height="20%" > 
                    Oggetto:  ${param.oggetto} 
                 </td> 
              </tr>
              <tr>
                 <td align="center" >
                   ${param.testo}
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
</c:otherwise>
</c:choose>                 
</TABLE>

<%@ include file="bottom.jspf"%>

