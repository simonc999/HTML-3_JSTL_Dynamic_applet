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
<%--------------- AUTORIZZAZIONE AREA LAB --------------------------------%>
<%------------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="4"/>
<c:set var="auth_page" value="home_lab.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Laboratorio"/>

<%@ include file="auth.jspf"%>


<%@ include file="top.jspf" %>

<form method="post" action="home_lab.jsp"> 

<td align="right" width="60" >

                                                <%-- COMANDO INDIETRO --%>
       

       <input type="hidden" name="id_test" value="${param.id_test}"/>
       <input type="image" name="submit" style="width:60px;height:60px" src="indietro.png"/>
</td> 
       </form>

<%@ include file="middle.jspf" %>
<sql:query var="vislab">
    select l.user_lab, l.nome, l.dirigente, l.link_sito, l.p_iva, l.sede_legale, u.mail, u.telefono
    from UTENTE_RUOLO u, LAB l
    where l.user_lab=u.username and l.user_lab="${user_userid}"
</sql:query>



                                              <%---TABELLA CON MODIFICA---%>


    <form method="post" action="#">

<input type="hidden" name="telefono" value="${param.telefono}"/>
<input type="hidden" name="ubicazione" value="${param.sede_legale}"/>      
<input type="hidden" name="mail" value="${param.mail}"/>    
   
   <c:if test="${empty param.bottone}">
    <table  align="center" width="80%" height="90%" cellspacing="0" cellpadding="3" bgcolor="#a5bacd" border="1" bordercolor="#007171">
    <tr>
        <td align="center">
           <img src="profilo2.png" align="center" width="15%"/>
       <font size="5" color="black"><b>Profilo di ${vislab.rows[0].nome}</b></font>
        </td>
         <td >
               <p><font color="#007171" size="4" face="Arial"><b>Nome</b></font></p>
                ${vislab.rows[0].nome}   
        
               <p><font color="#007171" size="4" face="Arial"><b>Dirigente</b></font></p>
                ${vislab.rows[0].dirigente}   
        
               <p><font color="#007171" size="4" face="Arial"><b>Sito</b></font></p>
                ${vislab.rows[0].link_sito}   
        </td>  
        <td>
    
             <p><font color="#007171" size="4" face="Arial"><b>Username</b></font></p>
             ${vislab.rows[0].user_lab}   
            
            
              <p><font color="#007171" size="4" face="Arial"><b>E-mail</b></font></p>
              ${vislab.rows[0].mail}   
        </td>          
                   
        <td>    
                 
                 <p><font color="#007171" size="4" face="Arial"><b>Recapito telefonico</b></font></p>
                  ${vislab.rows[0].telefono}   
        
                  <p><font color="#007171" size="4" face="Arial"><b>Sede Legale</b></font></p>
                  ${vislab.rows[0].sede_legale}
                 
                  <p><font color="#007171" size="4" face="Arial"><b>Partita Iva</b></font></p>
                  ${vislab.rows[0].p_iva}   
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



                                                        <%---TABELLA CON SALVA E RESET---%>
                                               <%--messaggio di salvataggio effettuato con successo---%>



<c:if test="${not empty profilo_salvato}">
<p align="center">
<font color="green">${profilo_salvato}</font>
</p>
</c:if>

</c:if>
   
      
</form>




<c:if test="${not empty param.bottone}">
<form method="post" action="salva_profilo_lab.jsp">
   <table align="center" width="80%" height="90%" cellspacing="0" cellpadding="3" bgcolor="#a5bacd" border="1" bordercolor="#007171">
      <tr>
        <td align="center">
           <img src="profilo2.png" align="center" width="15%"/>
           <font size="5" color="black"><b>Profilo di ${vislab.rows[0].nome}</b>
           </font>
        </td>
        <td >
               <p><font color="#007171" size="4" face="Arial"><b>Nome</b></font></p>
                ${vislab.rows[0].nome}   
        
               <p><font color="#007171" size="4" face="Arial"><b>Dirigente</b></font></p>
                ${vislab.rows[0].dirigente}   
        
               <p><font color="#007171" size="4" face="Arial"><b>Sito</b></font></p>
                ${vislab.rows[0].link_sito}   
        </td>  
        <td>
    
             <p><font color="#007171" size="4" face="Arial"><b>Username</b></font></p>
             ${vislab.rows[0].user_lab}   
            
            
              <p><font color="#007171" size="4" face="Arial"><b>E-mail</b></font></p>
              <input type="text" name="mail" value="${vislab.rows[0].mail}"/>
        </td>          
                   
        <td>    
                 
                 <p><font color="#007171" size="4" face="Arial"><b>Recapito telefonico</b></font></p>
                  <input type="text" name="telefono" value="${vislab.rows[0].telefono}"/> 
        
                  <p><font color="#007171" size="4" face="Arial"><b>Sede Legale</b></font></p>
                  <input type="text" name="ubicazione" value="${vislab.rows[0].sede_legale}"/>   
       
                 <p><font color="#007171" size="4" face="Arial"><b>Partita Iva</b></font></p>
                  ${vislab.rows[0].p_iva}   
         
        </td>

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



<%@ include file="bottom.jspf" %>