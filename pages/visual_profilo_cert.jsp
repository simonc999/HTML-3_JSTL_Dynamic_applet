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
<%--------------- AUTORIZZAZIONE AREA CERT --------------------------------%>
<%------------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="3"/>
<c:set var="auth_page" value="home_cert.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Certificatore"/>

<%@ include file="auth.jspf"%>

<%--------------------------------%>
<%---- FRAMMENTO TOP--------------%>
<%--------------------------------%>
<%@ include file="top.jspf"%>

<td align="right" width="60" >
        <!-- COMANDO INDIETRO -->
       <a href="home_cert.jsp"> 
            <img style="width:60px;height:60px" src="indietro.png">
       </a>
     </td>

<%--------------------------------%>
<%---- FRAMMENTO MIDDLE  ---------%>
<%--------------------------------%>
<%@ include file="middle.jspf"%>


<%---QUERY PER ESTRARRE I DATI DEL CERTIFICATORE----%>

<sql:query var="viscert">
    select c.user_cert, c.nome, c.cognome, c.n_albo, c.data_nascita, c.ubicazione, u.mail, u.telefono, c.sesso, c.cf
    from UTENTE_RUOLO u, CERT c
    where c.user_cert=u.username and 
    c.user_cert="${user_userid}"
</sql:query>

<%---TABELLA PER RIPORTARE I DATI ESTRATTI DALLA QUERY, CON UN TASTO CHE DA' LA POSSIBILITA' DI MODIFICARE---%>

    <form method="post" action="#">

		<input type="hidden" name="telefono" value="${param.telefono}"/>
		<input type="hidden" name="ubicazione" value="${param.ubicazione}"/>      
		<input type="hidden" name="mail" value="${param.mail}"/>    
   
   <c:if test="${empty param.bottone}">
    <table  align="center" width="80%" height="90%" cellspacing="0" cellpadding="3" bgcolor="#a5bacd" border="1" bordercolor="#007171">
		<tr>
			<td align="center">
			   <img src="profilo2.png" align="center" width="15%"/>
			   <font size="5" color="black"><b>Profilo di ${viscert.rows[0].nome} ${viscert.rows[0].cognome}</b></font>
			</td>
			<td >
				   <p><font color="#007171" size="4" face="Arial"><b>Nome</b></font></p>
					${viscert.rows[0].nome}   
			
				   <p><font color="#007171" size="4" face="Arial"><b>Cognome</b></font></p>
					${viscert.rows[0].cognome}   
					<p><font color="#007171" size="4" face="Arial"><b>Codice fiscale</b></font></p>
					${viscert.rows[0].cf}
			
				   <p><font color="#007171" size="4" face="Arial"><b>Data di nascita</b></font></p>
					${viscert.rows[0].data_nascita}   
			</td>  
			<td>
		
				   <p><font color="#007171" size="4" face="Arial"><b>Username</b></font></p>
				    ${viscert.rows[0].user_cert}   
				
				
				   <p><font color="#007171" size="4" face="Arial"><b>E-mail</b></font></p>
				    ${viscert.rows[0].mail}   
		  
				   <p><font color="#007171" size="4" face="Arial"><b>Sesso</b></font></p>
					<c:if test="${viscert.rows[0].sesso=='M'}">
							   Maschio
					</c:if>
					<c:if test="${viscert.rows[0].sesso=='F'}">
							   Femmina
					</c:if>
			</td>  		   
			<td> 
					 <p><font color="#007171" size="4" face="Arial"><b>Recapito telefonico</b></font></p>
					  ${viscert.rows[0].telefono}   
			
					  <p><font color="#007171" size="4" face="Arial"><b>Sede Legale</b></font></p>
					  ${viscert.rows[0].ubicazione}   
			 
					 <p><font color="#007171" size="4" face="Arial"><b>Numero albo</b></font></p>
					  ${viscert.rows[0].n_albo}   
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
	
<%---TABELLA CON SALVA E RESET CHE TIENE CONTO DELLE MODIFICHE APPORTATE PRECEDENTEMENTE---%>

<%--messaggio di salvataggio effettuato con successo---%>

		<c:if test="${not empty profilo_salvato}">
			<p align="center">
				<font color="green">${profilo_salvato}</font>
			</p>
		</c:if>
		
		</c:if>
   
      
	</form>



<%---CICLO CHE CONTROLLA CHE SIA STATO SCHIACCIATO IL BOTTONE CHE ABILITA LE MODIFICHE---%>

<c:if test="${not empty param.bottone}">

    <%---FORM CHE RIMANDA ALLA ACTION CHE PERMETTE IL SALVATAGGIO DEI DATI MODIFICATI---%>

	<form method="post" action="salva_profilo_cert.jsp">
		<table align="center" width="80%" height="90%" cellspacing="0" cellpadding="3" bgcolor="#a5bacd" border="1" bordercolor="#007171">
			<tr>
				<td align="center">
				   <img src="profilo2.png" align="center" width="15%"/>
				   <font size="5" color="black"><b>Profilo di ${viscert.rows[0].nome} ${viscert.rows[0].cognome}</b>
				   </font>
				</td>
		
				<td >
					   <p><font color="#007171" size="4" face="Arial"><b>Nome</b></font></p>
						${viscert.rows[0].nome}   
				
					   <p><font color="#007171" size="4" face="Arial"><b>Cognome</b></font></p>
						${viscert.rows[0].cognome}   
				
					   <p><font color="#007171" size="4" face="Arial"><b>Data di nascita</b></font></p>
						${viscert.rows[0].data_nascita}   
				</td>  
				<td>
			
					 <p><font color="#007171" size="4" face="Arial"><b>Username</b></font></p>
					 ${viscert.rows[0].user_cert}   
					
					
					  <p><font color="#007171" size="4" face="Arial"><b>E-mail</b></font></p>
					  <input type="text" name="mail" value="${viscert.rows[0].mail}"/>
			  
					 <p><font color="#007171" size="4" face="Arial"><b>Sesso</b></font></p>
						<c:if test="${viscert.rows[0].sesso=='M'}">
								   Maschio
						</c:if>
						<c:if test="${viscert.rows[0].sesso=='F'}">
								   Femmina
						</c:if>
				</td>            
				<td>    
						 
						 <p><font color="#007171" size="4" face="Arial"><b>Recapito telefonico</b></font></p>
						  <input type="text" name="telefono" value="${viscert.rows[0].telefono}"/> 
				
						  <p><font color="#007171" size="4" face="Arial"><b>Sede Legale</b></font></p>
						  <input type="text" name="ubicazione" value="${viscert.rows[0].ubicazione}"/>   
				 
						 <p><font color="#007171" size="4" face="Arial"><b>Numero albo</b></font></p>
						  ${viscert.rows[0].n_albo}   
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



<%--------------------------------%>
<%---- FRAMMENTO BOTTOM  ---------%>
<%--------------------------------%>
<%@ include file="bottom.jspf"%>
 