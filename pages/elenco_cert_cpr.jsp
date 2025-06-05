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
<%@include file="top.jspf"%>


<%--------------------------------------------------------------------------------------%>
<%------------------------------    COMANDO INDIETRO   ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
    <td align="right"  width="60">
      <a href="home_cpr.jsp"> 
          <img src="indietro.png" style="width:60px;height:60px"/>
      </a>
    </td> 

<%----------------------------------------------------------------------------------%>
<%--QUERY CONVALIDATO--%>
<%----------------------------------------------------------------------------------%>
<sql:query var="mes">
SELECT messaggio 
FROM CPR
WHERE user_cpr LIKE ?
      <sql:param value="${user_userid}"/>
</sql:query>


<c:if test="${mes.rows[0].messaggio}">
  <sql:update>
   UPDATE CPR
   SET messaggio = false
   WHERE user_cpr LIKE ?
   <sql:param value="${user_userid}"/>
   </sql:update>
</c:if>


<%--------------------------------------------------------------------------------------%>
<%----------------------------    FRAMMENTO MIDDLE      --------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@include file="middle.jspf"%>


<%--------------------------------------------------------------------%>
<%---     QUERY CHE ESTRAE LE CPR AFFILIATE AL CERT CHE 
                SELEZIONO CON IL TASTO SUBMIT 'CPR AFFILIATE'      ---%>
<%--------------------------------------------------------------------%>
 <c:if test="${not empty param.CPR}">
 <sql:query var="cpr">
 SELECT c.nome, c.dirigente, c.link_sito, c.user_cpr
 FROM CPR c, SCHEDA_PROD s
 WHERE c.user_cpr=s.user_cpr
 AND c.user_cpr <> ?
 AND s.user_cert  LIKE ?
 <sql:param value="${user_userid}"/>
 <sql:param value="${param.user}"/>
 GROUP BY c.nome, c.dirigente, c.link_sito, c.user_cpr
 </sql:query>
</c:if>


<%--------------------------------------------------------------------%>
<%---          QUERY CHE ESTRAE TUTTI I CERTIFICATORI              ---%>
<%--------------------------------------------------------------------%>
<sql:query var="cert">
 select c.nome, c.cognome, c.user_cert, c.n_albo, u.mail
 from CERT c, UTENTE_RUOLO u
 where c.user_cert=u.username 
</sql:query>



<%-------------------------------------------------------------------------------------------------------------%>
<%------------------- ESTRAZIONE DI TUTTE LE PRATICHE COCNLUSE DI OGNI CERT DAL DB ----------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
  <sql:query var="cert_ban">
        select data_inizio_ban, data_fine_ban, user_cert
        from BAN 
        where user_cert LIKE ?
        and user_cpr LIKE ?
   <sql:param value="${param.user}"/>
   <sql:param value="${user_userid}"/>
    </sql:query>


<%----------------------------------------------------------------------------%>
<%--- CONVERSIONE DATE                                                     ---%>
<%----------------------------------------------------------------------------%>
<fmt:formatDate var="var_data_inizio" 
                value="${cert_ban.rows[0].data_inizio_ban}"
                pattern="yyyy-MM-dd"/>

<fmt:formatDate var="var_ora_inizio"
                value="${cert_ban.rows[0].data_inizio_ban}"
                type="time"
                pattern="HH:mm"/>

<fmt:formatDate var="var_data_fine" 
                value="${cert_ban.rows[0].data_fine_ban}"
                pattern="yyyy-MM-dd"/>

<fmt:formatDate var="var_ora_fine"
                value="${cert_ban.rows[0].data_fine_ban}"
                type="time"
                pattern="HH:mm"/>


<TABLE height="100%" width="80%" border="0">
 <td>
       
  <table align="left" width="910" border="0" bordercolor="007171">
  <caption align="top"><h1><font color="007171">ELENCO CERTIFICATORI</font></h1></caption>

<p> <font color="green" size="3"> In questa sezione puoi visionare tutti i certificatori che lavorano con Alambiccus S.R.L. <br/> Se  l'operato di qualcuno di loro non ti soddisfa, clicca sul banner, cosi l'agenzia governativa non gli affidera' i tuoi prodotti.  </font></p>

  <tr  bgcolor="#007171" >
   <th align="center" width="100" height="10%"><font color="#9ad6d6" face="Arial"><b> USERNAME     </b></font>          </th>
   <th align="center" width="125" height="10%"><font color="#9ad6d6" face="Arial"><b> NOME COGNOME </b></font>          </th>
   <th align="center" width="135" height="10%"><font color="#9ad6d6" face="Arial"><b> MAIL         </b></font>          </th>
   <th align="center" width="125" height="10%"><font color="#9ad6d6" face="Arial"><b>N. ALBO       </b></font>          </th>
   <th align="center" width="100" height="10%"><font color="#9ad6d6" face="Arial"><b>
      PRATICHE <img title="Numero pratiche con stato del prodotto in corso" src="giallo.png" width="15" height="15"/></b></font> 
   </th>
   <th align="center" width="100" height="10%"><font color="#9ad6d6" face="Arial"><b>
        PRATICHE <img title="Numero pratiche con stato del prodotto non certificato" src="rosso.png" width="15" height="15"/>
</b></font>                
   </th>
    <th align="center" width="100" height="10%"><font color="#9ad6d6" face="Arial"><b>
       PRATICHE <img title="Numero pratiche con stato del prodotto certificato" src="verde.png" width="15" height="15"/></b></font> 
    </th>
    <th align="center" width="125" height="10%"><font color="#9ad6d6" face="Arial"><b>OPZIONI </b></font>                            </th>
  </tr>
   </table>
            
       
            <div style="width:960px; overflow:hidden">
            <div style="width:985px; height:300px; overflow-y:scroll; padding-right:0px">
            <table align="left" width="910" border="1" bgcolor="white" bordercolor="bbccdc"> 
            <c:forEach items="${cert.rows}" var="row">


<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%--------------------------- ESTRAZIONE PRATICHE IN CORSO DI OGNI CERT DAL DB --------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

  <sql:query var="p_incorso">
        select S.id_scheda
        from SCHEDA_PROD S 
        where S.inizio_prat IS NOT NULL and
              S.stato = 2 and
              S.user_cert LIKE ?
   <sql:param value="${row.user_cert}"/>
    </sql:query>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------- ESTRAZIONE PRATICHE CONCLUSE CON SUCCESSO DI OGNI CERT DAL DB ---------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

  <sql:query var="p_consucc">
        select S.id_scheda
        from SCHEDA_PROD S 
        where S.fine_prat IS NOT NULL and
              S.stato=1 and
              S.user_cert LIKE ?
   <sql:param value="${row.user_cert}"/>
    </sql:query>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------- ESTRAZIONE PRATICHE CONCLUSE NONCON SUCCESSO DI OGNI CERT DAL DB ------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

  <sql:query var="p_nosucc">
        select S.id_scheda
        from SCHEDA_PROD S 
        where S.fine_prat IS NOT NULL and
              S.stato=3 and
              S.user_cert LIKE ?
   <sql:param value="${row.user_cert}"/>
    </sql:query>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%------------------- ESTRAZIONE DI TUTTE LE PRATICHE COCNLUSE DI OGNI CERT DAL DB ----------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

  <sql:query var="tot_pratiche">
        select S.id_scheda
        from SCHEDA_PROD S 
        where S.fine_prat IS NOT NULL and (S.stato = 1 or S.stato = 3) and
              S.user_cert LIKE ?
   <sql:param value="${row.user_cert}"/>
    </sql:query>

<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------         ESTRAZIONE DI TUTTI I CERTIFICATORI BANNATI          ----------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>
<%-------------------------------------------------------------------------------------------------------------%>

  <sql:query var="ban_user">
        select user_cert
        from BAN 
        where user_cpr LIKE ? 
        and user_cert LIKE ?
     <sql:param value="${user_userid}"/>
     <sql:param value="${row.user_cert}"/>
    </sql:query>



<%------ CALCOLO IL NUMERO DI PRATICHE IN CORSO  ------%>
<c:set var="n_p_incorso"  value="${p_incorso.rowCount}"/>



<%------ CALCOLO IL NUMERO DI PRATICHE CONCLUSE CON SUCCESSO  ------%>
<c:set var="n_p_succ"     value="${p_consucc.rowCount}"/>


<%------ CALCOLO IL NUMERO DI PRATICHE CONCLUSE CON ESITO NEGATIVO  ------%>
<c:set var="n_p_nosucc"   value="${p_nosucc.rowCount}"/>


<%------ CALCOLO IL NUMERO DI PRATICHE CONCLUSE TOTALI  ------%>
<c:set var="n_tot"        value="${tot_pratiche.rowCount}"/>


<c:choose>
 <c:when test="${n_tot>0}">
<c:set var="percentuale" value="${(n_p_succ/n_tot)*100}"/>
 </c:when>
 <c:otherwise>
  <c:set var="percentuale" value="0"/>
</c:otherwise>
</c:choose>
       
             <tr>
                <td width="100" valign="middle">
                <c:if test="${row.user_cert != ban_user.rows[0].user_cert}"> <font color="black" face="Arial">    ${row.user_cert}</font> </c:if>
                <c:if test="${row.user_cert == ban_user.rows[0].user_cert}"> <font color="red" face="Arial">    ${row.user_cert}</font> <img title="Utente bannato!" src="ban.png" width="15" height="15"/> </c:if>
 </td>
                <td width="125"><font face="Arial">${row.nome} ${row.cognome}   <br/> 

                 <%----VALUTAZIONE CERT-------%>
<c:if test="${percentuale>10 }"><img title="${percentuale}%" width="15" height="15"  src="stella_gialla.png"/>
<c:if test="${percentuale>30 }"><img title="${percentuale}%" width="15" height="15"  src="stella_gialla.png"/>
<c:if test="${percentuale>50 }"><img title="${percentuale}%" width="15" height="15"  src="stella_gialla.png"/>
<c:if test="${percentuale>70 }"><img title="${percentuale}%" width="15" height="15"  src="stella_gialla.png"/>
<c:if test="${percentuale>90 }"><img title="${percentuale}%" width="15" height="15"  src="stella_gialla.png"/>
                 </c:if>
                 </c:if>
                 </c:if>
                 </c:if>
                 </c:if> 

      </font>   </td>
                <td width="135"><font face="Arial">${row.mail}                         </font>   </td>
                <td width="125"><font face="Arial">${row.n_albo}                       </font>   </td>
                <td width="100"><font face="Arial">${n_p_incorso}                      </font>   </td>
                <td width="100"><font face="Arial">${n_p_nosucc}                         </font>   </td>
                <td width="100"><font face="Arial">${n_p_succ}                       </font>   </td>
                <td width="125" align="center">
                 <form method="post" action="#">
                   <input type="hidden" name="nome_cert" value="${row.nome}"/>
                   <input type="hidden" name="cognome_cert" value="${row.cognome}"/>
                   <input type="hidden" name="user" value="${row.user_cert}"/>
                   <input type="hidden" name="data_ban" value="${param.data_ban}"/>
                   <input type="hidden" name="ora_ban" value="${param.ora_ban}"/>
                  <input type="submit" value="CPR AFFILIATE" name="CPR"/>    </br>
                 
                   
                  <input type="submit" value="BAN" name="ban"/>    </br>
                 </form>                                                                         </td>

            </tr>
            </c:forEach>
                                 
         </table>
         </div>
         </div>
        </td>  

<%----------------------------------------------------------------------------------%>
<%--- TABELLA LATERALE CHE APPARE QUANDO CLICCO SUL TASTO BAN DEL RELATIVO CERT  ---%> 
<%----------------------------------------------------------------------------------%>     
 <c:if test="${not empty param.ban}">
  <td>
  <table width="300" height="50%" border="1" cellpadding="8" cellspacing="0"  bordercolor="#008080" bgcolor="#a5bacd" align="left">
  <form action="action_ban.jsp" method="post">
   <input type="hidden" name="user" value="${param.user}"/>
                <tr style="margin-right:8px;">
                    <td align="center" bgcolor="#a5bacd" >
                        <font size="4"> BAN</font>
                    
                    <br/>
                  <font color="red">  Inserisci la data d' inizio in cui vuoi impostare il ban per ${param.nome_cert} ${param.cognome_cert} <br/>
                   (*)</font> 
                   <input type="date" name="data_ban" 
                    <c:if test="${not empty var_data_inizio}">
                    value="${var_data_inizio}"
                    </c:if>/>
                   <input type="time" name="ora_ban"   
                    <c:if test="${not empty var_ora_inizio}">
                    value="${var_ora_inizio}"
                     </c:if>/>   <br/> <br/> <br/>
                    
                    L'inserimento della data di fine del ban e' opzionale.<br/>
                    Se decidi di non compilarla il ban non avra' una fine, ma potrai comunque inserirla in un secondo momento.<br/>
                  

                    
                 
                    <input type="date" name="fine_data_ban" min="${var_data_inizio}"
                     <c:if test="${not empty var_data_fine}">
                      value="${var_data_fine}" 
                     </c:if>/>
                 
                    <input type="time" name="fine_ora_ban"
                    <c:if test="${not empty var_ora_fine}">     
                     value="${var_ora_fine}"
                     </c:if>/>
                  
                    <br/> <br/> <br/>



          <c:choose>

<%------------------------------------------------------------------%>
<%------ SOLO SE IL CERTIFICATORE E' STATO GIA' BANNATO, SI VEDONO
                I BOTTONI'MODIFICA BAN' E 'ELIMINA BAN'       ------%>
<%------------------------------------------------------------------%>
             <c:when test="${not empty cert_ban.rows[0].data_inizio_ban}">
                    <input type="submit" name="modifica" value="Modifica ban" />
                    <input type="submit" name="elimina" value="Rimuovi ban" />
               
               </c:when>   

<%------------------------------------------------------------------%>
<%------      SOLO SE IL CERTIFICATORE NON E' STATO BANNATO, 
                     SI VEDE IL BOTTONE 'CONFERMA BAN'        ------%>
<%------------------------------------------------------------------%>
               <c:otherwise>
                   <input type="submit" name="banna" value="Conferma ban" />
               </c:otherwise>
          </c:choose> 
         </form>
<br/><br/>
                

           <font color="red" size="2">(*) campo obbligatorio! </font>
            </td>  
          </tr>
             
         </table>
</td> 

            <td valign="top" align="right">
             
            <form method="post" action"#">
  <br/><br/><br/><br/><br/>      
             <input type="image" name="submit" style="width:20px;height:20px" src="rosso1.png"/>
             </form>
            </td>                   
          

            </c:if>

<%---------------------------------------------------------------------------------%>
<%--- TABELLA  CON TUTTI I CERT AFFILIATI CHE APPARE QUANDO CLICCO IL SUBMIT CPR --%>
<%---------------------------------------------------------------------------------%>
 <c:if test="${not empty param.CPR}">
 
<%--------------------------------------------------------------%>
<%-- SE CI SONO CPR AFFILIATE ASSOCIATE AL CERT SELEZIONATO, 
     APPARE UNA TABELLA CON L'ELENCO IN DETTAGLIO DELLE CPR   --%>
<%--------------------------------------------------------------%>
 <c:if test="${cpr.rowCount > 0}">
 <td>
 <table  width="350" border="1" cellpadding="8" cellspacing="0"  
     bordercolor="#008080" bgcolor="#a5bacd" align="left">
    <tr><th> NOME CPR  </th>
        <th> DIRIGENTE </th>
        <th> SITO      </th>  
    </tr>
        <c:forEach var="dettagli_cpr" items="${cpr.rows}">
        <tr>  <td>         ${dettagli_cpr.nome}               </td>
              <td>         ${dettagli_cpr.dirigente}          </td>
              <td>         ${dettagli_cpr.link_sito}          </td>
        </tr>
        </c:forEach>
    </table>
 </td>
 <td valign="top" align="right">
             
            <form method="post" action"#">
  <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>   
             <input type="image" name="submit" style="width:20px;height:20px" src="rosso1.png"/>
             </form>
            </td>                   
          
 </c:if>

<%--------------------------------------------------------------%>
<%--       SE NON CI SONO CPR AFFILIATE ASSOCIATE AL CERT 
             SELEZIONATO, APPARE UN MESSAGGIO DI AVVISO       --%>
<%--------------------------------------------------------------%>
 <c:if test="${cpr.rowCount == 0}">
   <td>
   <table valign="top" width="300" border="1" cellpadding="8" cellspacing="0"  
     bordercolor="#008080" bgcolor="#a5bacd" align="left"> <tr><td>
     Questo certificatore non ha lavorato e non lavora con nessuna CPR!
    </td></tr>
   </table>
  </td>
  <td valign="top" align="right">
             
            <form method="post" action"#">
  <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
             <input type="image" name="submit" style="width:20px;height:20px" src="rosso1.png"/>
             </form>
            </td>                   
          
 </c:if>
 

 </c:if>

<%----------------------------------------------------------------%>
<%---- MESSAGGI DI ERRORE PROVENIENTI DALLA 'ACTION_BAN.JSP'  ----%>
<%----------------------------------------------------------------%>
<font size="3" color="red">   ${msg} 
                              ${errore1}
                              ${errore2}
 
</font>
<%----------------------------------------------------------------%>
<%---- MESSAGGI DI VERIFICA PROVENIENTI DALLA 'ACTION_BAN.JSP'----%>
<%----------------------------------------------------------------%>
<font size="3" color="green"> ${caricato_no_fine}  
                              ${caricato_si_fine}
                              ${modificato_si_fine}
                              ${modificato_no_fine} 
                              ${ban_eliminato}

</font>


           
</td>
</TABLE>


<%--------------------------------------------------------------------------------------%>
<%----------------------------    FRAMMENTO BOTTOM      --------------------------------%>
<%--------------------------------------------------------------------------------------%>
<%@ include file="bottom.jspf" %>
