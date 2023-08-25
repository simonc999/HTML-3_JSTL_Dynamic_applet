<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%--------------------------------------------------------------------------------------%>
<%------------------------------AUTORIZZAZIONE AREA CPR---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<c:set var="auth_cod_ruolo" value="5"/>
<c:set var="auth_page" value="home_cpr.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Casa Produttrice"/>

<%@ include file="auth.jspf"%>


<%--------------------------------------------------------------------------------------%>
<%----------------------------    FRAMMENTO TOP         --------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="top.jspf" %>

<%--------------------------------------------------------------------------------------%>
<%------------------------------    COMANDO INDIETRO   ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
     <td align="right" width="60" >
       <a href="home_cpr.jsp"> 
         <img style="width:60px;height:60px" src="indietro.png"/>
       </a>
     </td>


<%-----------------------------------------------------------------%>
<%-------- QUERY CHE ESTRAE I DATI DAL DB RELATIVI AL
             PROFILO DELLA CPR LOGGATA                         ----%>
<%-----------------------------------------------------------------%>
<sql:query var="profilo">
SELECT c.nome, c.p_iva, c.link_sito, c.mercato, c.sede_legale, c.dirigente, u.username, u.mail, u.telefono
FROM CPR c, UTENTE_RUOLO u
where c.user_cpr=u.username 
and u.username LIKE ?
 <sql:param value="${user_userid}"/>

</sql:query>


<%--------------------------------------------------------------------------------------%>
<%----------------------------    FRAMMENTO MIDDLE      --------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="middle.jspf" %>




<%------------------------------------------------------------------------%>
<%--------             TABELLA CON MODIFICA 
               (SE NON CLICCO SUL BOTTONE DEL MODIFICA PROFILO)       ----%>
<%------------------------------------------------------------------------%>

    <form method="post" action="visual_profilo.jsp">

<input type="hidden" name="dirigente" value="${param.dirigente}"/> 
<input type="hidden" name="telefono" value="${param.telefono}"/> 
<input type="hidden" name="mail" value="${param.mail}"/>
<input type="hidden" name="sito" value="${param.sito}"/>
<input type="hidden" name="sede_legale" value="${param.sede_legale}"/>  
   

   <c:if test="${empty param.bottone}">
    <table  align="center" width="80%" height="90%" cellspacing="0" cellpadding="3" bgcolor="#a5bacd" border="1" bordercolor="#007171">
    <tr>
      <td align="center">
           <img src="profilo2.png" align="center" width="15%"/>
       <font size="5" color="black"><b>Profilo di ${profilo.rows[0].nome} </b></font>
      </td>
      <td >
               <p><font color="#007171" size="4" face="Arial"><b>Nome Azienda</b></font></p>
                ${profilo.rows[0].nome} 
         
               <p><font color="#007171" size="4" face="Arial"><b>P.IVA</b></font></p>
               ${profilo.rows[0].p_iva}
         
               <p><font color="#007171" size="4" face="Arial"><b>Link sito azienda</b></font></p>
               <span class="textbox"> 
                 http://
                 ${profilo.rows[0].link_sito}
               </span>
              
                <p><font color="#007171" size="4" face="Arial"><b>Mercato </b></font></p>
               <c:if test="${profilo.rows[0].mercato=='Internazionale'}">
                          Internazionale    
                </c:if>
                <c:if test="${profilo.rows[0].mercato=='Italiano'}">
                           Italiano
                </c:if>
                 <c:if test="${profilo.rows[0].mercato=='Europeo'}">
                           Europeo
                </c:if>   
                <p><font color="#007171" size="4" face="Arial"><b>Sede Legale</b></font></p>
                     ${profilo.rows[0].sede_legale}  

              
                  
      </td>  
      <td>
             
             <p><font color="#007171" size="4" face="Arial"><b>Dirigente</b></font></p>
                 ${profilo.rows[0].dirigente}
    
             <p><font color="#007171" size="4" face="Arial"><b>Username</b></font></p>
              ${profilo.rows[0].username}    
            
            
              <p><font color="#007171" size="4" face="Arial"><b>E-mail</b></font></p>
              ${profilo.rows[0].mail}   
      
                     
                       
               <p><font color="#007171" size="4" face="Arial"><b>Recapito telefonico</b></font></p>
              ${profilo.rows[0].telefono}

                 
                
     </td>
    </tr>
  
    <tr>
        <td width="40%">&nbsp</td>
        <td align="center" colspan="4">
            <font size="5" face="Arial">
            <input type="submit" name="bottone" value="Modifica Profilo"/>
        </td>
    </tr>
</table>



<%------------------------------------------------------------%>
<%--------             TABELLA CON SALVA E RESET          ----%>
<%------------------------------------------------------------%>

<%--messaggio di salvataggio effettuato con successo---%>
 
 <c:if test="${not empty profilo_salvato}">
     <p align="center">
     <font color="green">${profilo_salvato}</font>
     </p>

  </c:if>
</c:if>


</form>



<%------------------------------------------------------------------------%>
<%--------      SE CLICCO SUL BOTTONE DEL MODIFICA PROFILO       ---------%>
<%------------------------------------------------------------------------%>

<c:if test="${not empty param.bottone}">
<form method="post" action="salva_profilo.jsp">




   <table align="center" width="80%" height="90%" cellspacing="0" cellpadding="3" bgcolor="#a5bacd" border="1" bordercolor="#007171">
      <tr>
        <td align="center">
           <img src="profilo2.png" align="center" width="15%"/>
           <font size="5" color="black"><b>Profilo di ${profilo.rows[0].nome}</b>
           </font>
        </td>
        <td >
               <p><font color="#007171" size="4" face="Arial"><b>Nome Azienda</b></font></p>
                ${profilo.rows[0].nome} 
         
               <p><font color="#007171" size="4" face="Arial"><b>P.IVA</b></font></p>
               ${profilo.rows[0].p_iva}
         
               <p><font color="#007171" size="4" face="Arial"><b>Link sito azienda</b></font></p>
               <span class="textbox"> 
                 http://
                <input type="text" name="sito" value="${profilo.rows[0].link_sito}"/>
               </span>
              
                <p><font color="#007171" size="4" face="Arial"><b>Mercato </b></font></p>
        
               <select name="mercato">
                <c:forTokens var="mercato" items="Italiano,Europeo,Internazionale" delims=",">
                 <option value="${mercato}"  
                    
                       <c:if test="${profilo.rows[0].mercato == mercato}">
                             selected="selected"
                       </c:if>
                   
                 >${mercato}</option>
              </c:forTokens>
               </select>
 
                <p><font color="#007171" size="4" face="Arial"><b>Sede Legale</b></font></p>
                 <input type="text" name="sede_legale" value="${profilo.rows[0].sede_legale}"/>   

              
                  
        </td>  
        <td>
              <p><font color="#007171" size="4" face="Arial"><b>Dirigente</b></font></p>
                <input type="text" name="dirigente" value="${profilo.rows[0].dirigente}"/>
              
             <p><font color="#007171" size="4" face="Arial"><b>Username</b></font></p>
              ${profilo.rows[0].username}
            
            
            
              <p><font color="#007171" size="4" face="Arial"><b>E-mail</b></font></p>
             <input type="text" name="mail" value="${profilo.rows[0].mail}"/>  
      
                     
                       
             <p><font color="#007171" size="4" face="Arial"><b>Recapito telefonico</b></font></p>
             <input type="text" name="telefono" value="${profilo.rows[0].telefono}"/>
                 
                
        </td>
    </tr>

    <tr>
            <td width="40%">&nbsp</td>
            <td align="center"colspan="4">
                <font size="5" face="Arial">
                <input type="submit" name="bottone2" value="Salva"/>&nbsp&nbsp
                
             </td>
    </tr>


    </tr>  
</table> 
</form>  

</c:if>



       


<%--------------------------------------------------------------------------------------%>
<%------------------------------     FRAMMENTO BOTTOM  ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="bottom.jspf" %>