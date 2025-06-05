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

<%---------------------------------------------------------------------------------%>
<%--  VALIDATORE: CONTROLLO CHE SIANO STATI SALVATI TUTTI I CAMPI, ALTRIMENTI 
    RESTITUISCO UN MESSAGGIO DI ERRORE NELLA PAGINA PRECEDENTE (modifica_scheda) --%>
<%---------------------------------------------------------------------------------%>
 
<c:if test="${empty fn:trim(param.nome_prod)       || 
              empty fn:trim(param.uso_prod)        ||
              empty fn:trim(param.materiali_prod)  ||
              empty fn:trim(param.tipo_prod)       || 
              empty fn:trim(param.beneficio_prod)  }">

<%------------------------------------------------------------%>
<%----- MESSAGGIO DI ERRORE SE CI SONO I CAMPI VUOTI ---------%>
<%------------------------------------------------------------%>
<c:set var="errore" scope="request"> <font color="red" size="4">
E' necessario compilare tutti i campi prima di procedere al salvataggio! </font>
</c:set>
<jsp:forward page="modifica_scheda.jsp">
<jsp:param name="errore" value="true"/>
</jsp:forward>
</c:if> 



<c:choose> 
<c:when test="${not empty param.id_scheda}">

<%-------------------------------------------------------------%>
<%---------------TRASFERIMENTO IMMAGINE SU UN FILE ------------%>
<%-------------------------------------------------------------%>
<%----NEL RESULT METTO UNA VARIABILE: foto_disponibile--------
--------------perche' la foto e' un campo opzionale!------------
-------------la foto la inserisco in un file non nel db-------%>
<%-----------------------------------------------------------%>


<upload:saveFileContents inputName="form_foto1" 
                         result="foto_disponibile1"
                         fileName="foto1${param.id_scheda}.jpg"/>

<upload:saveFileContents inputName="form_foto2" 
                         result="foto_disponibile2"
                         fileName="foto2${param.id_scheda}.jpg"/>

<upload:saveFileContents inputName="form_foto3" 
                         result="foto_disponibile3"
                         fileName="foto3${param.id_scheda}.jpg"/>
<c:if test="${empty foto_disponibile1 && empty foto_disponibile2 && empty foto_disponibile3}">
 <sql:update>
UPDATE SCHEDA_PROD SET nome_prod = ?,
                       user_cpr  = ?,
                       tipo      = ?,
                       uso       = ?,
                       materiali = ?,
                       beneficio = ?
     where id_scheda = ? 
     <sql:param value="${fn:trim(param.nome_prod)}"/>
     <sql:param value="${fn:trim(user_userid)}"/>
     <sql:param value="${fn:trim(param.tipo_prod)}"/>
     <sql:param value="${fn:trim(param.uso_prod)}"/>
     <sql:param value="${fn:trim(param.materiali_prod)}"/>
     <sql:param value="${fn:trim(param.beneficio_prod)}"/>
               <sql:param value="${param.id_scheda}"/>
  </sql:update>
</c:if>

<%------------------------------------------------------%>
<%-- SE SONO STATI COMPILATI TUTTI I CAMPI, 
     PROCEDO CON L'UPDATE (MODIFICA SCHEDA) ------------%>
<%------------------------------------------------------%>
<c:if test="${not empty foto_disponibile1}"> 
 <sql:update>
UPDATE SCHEDA_PROD SET nome_prod = ?,
                       user_cpr  = ?,
                       tipo      = ?,
                       uso       = ?,
                       materiali = ?,
                       beneficio = ?,
                       foto1     = ?
     where id_scheda = ? 
     <sql:param value="${fn:trim(param.nome_prod)}"/>
     <sql:param value="${fn:trim(user_userid)}"/>
     <sql:param value="${fn:trim(param.tipo_prod)}"/>
     <sql:param value="${fn:trim(param.uso_prod)}"/>
     <sql:param value="${fn:trim(param.materiali_prod)}"/>
     <sql:param value="${fn:trim(param.beneficio_prod)}"/>
      <sql:param value="foto1${param.id_scheda}.jpg"/>
               <sql:param value="${param.id_scheda}"/>
  </sql:update>
</c:if>

<c:if test="${not empty foto_disponibile2}"> 
 <sql:update>
UPDATE SCHEDA_PROD SET nome_prod = ?,
                       user_cpr  = ?,
                       tipo      = ?,
                       uso       = ?,
                       materiali = ?,
                       beneficio = ?,
                       foto2     = ?
     where id_scheda = ? 
     <sql:param value="${fn:trim(param.nome_prod)}"/>
     <sql:param value="${fn:trim(user_userid)}"/>
     <sql:param value="${fn:trim(param.tipo_prod)}"/>
     <sql:param value="${fn:trim(param.uso_prod)}"/>
     <sql:param value="${fn:trim(param.materiali_prod)}"/>
     <sql:param value="${fn:trim(param.beneficio_prod)}"/>
                <sql:param value="foto2${param.id_scheda}.jpg"/>
               <sql:param value="${param.id_scheda}"/>
  </sql:update>
</c:if>
<c:if test="${not empty foto_disponibile3}"> 
 <sql:update>
UPDATE SCHEDA_PROD SET nome_prod = ?,
                       user_cpr  = ?,
                       tipo      = ?,
                       uso       = ?,
                       materiali = ?,
                       beneficio = ?,
                       foto3     = ?
     where id_scheda = ? 
     <sql:param value="${fn:trim(param.nome_prod)}"/>
     <sql:param value="${fn:trim(user_userid)}"/>
     <sql:param value="${fn:trim(param.tipo_prod)}"/>
     <sql:param value="${fn:trim(param.uso_prod)}"/>
     <sql:param value="${fn:trim(param.materiali_prod)}"/>
     <sql:param value="${fn:trim(param.beneficio_prod)}"/>
                <sql:param value="foto3${param.id_scheda}.jpg"/>
               <sql:param value="${param.id_scheda}"/>
  </sql:update>
</c:if>


</c:when> 

<c:otherwise>

<%------------------------------------------------------%>
<%-- SE SONO STATI COMPILATI TUTTI I CAMPI, 
    PROCEDO CON L'INSERT (CREA NUOVA SCHEDA) -----------%>
<%------------------------------------------------------%>


<%--------------------------------------------------------%>
<%-----Passo1:  Trovo l'ultima scheda registrata ---------%>
<%--------------------------------------------------------%>
  <sql:query var="id_prod">
     select max(convert(substring(id_scheda,7),decimal)) as id_max 
     from SCHEDA_PROD
  </sql:query> 


<%----------------------------------------%>
<%-----Passo2:  Incremento di +1 ---------%>
<%----------------------------------------%>
  <c:if test="${not empty id_prod.rows}">
     <c:set var="id_scheda" value="${id_prod.rows[0].id_max + 1}"/>
  </c:if>

<%-------------------------------------------------------------%>
<%---------------TRASFERIMENTO IMMAGINE SU UN FILE ------------%>
<%-------------------------------------------------------------%>
<%----NEL RESULT METTO UNA VARIABILE: foto_disponibile--------
--------------perche' la foto e' un campo opzionale!------------
-------------la foto la inserisco in un file non nel db-------%>
<%-----------------------------------------------------------%>


<upload:saveFileContents inputName="form_foto1" 
                         result="foto_disponibile1"
                         fileName="foto1scheda${id_scheda}.jpg"/>


<upload:saveFileContents inputName="form_foto2" 
                         result="foto_disponibile2"
                         fileName="foto2scheda${id_scheda}.jpg"/>



<upload:saveFileContents inputName="form_foto3" 
                         result="foto_disponibile3"
                         fileName="foto3scheda${id_scheda}.jpg"/>

<%----------------------------------------------------------------%>
<%--------------INSERIMENTO DATI SCHEDA NEL DB--------------------%>
<%----------------------------------------------------------------%>
<sql:update>
  insert into SCHEDA_PROD (id_scheda, nome_prod, user_cpr, tipo, uso, materiali,beneficio, stato,foto1, foto2, foto3)
         values (?, ?, ?, ?, ?, ?, ?,?,?,?,?)
     <sql:param value="scheda${id_scheda}"/>
     <sql:param value="${param.nome_prod}"/>
     <sql:param value="${user_userid}"/>
     <sql:param value="${param.tipo_prod}"/>
     <sql:param value="${param.uso_prod}"/>
     <sql:param value="${param.materiali_prod}"/>
     <sql:param value="${param.beneficio_prod}"/>
     <sql:param value="0"/>



<%-----------------------------------------------------------%>
<%---  siccome non e'obbligatorio inserire la foto, solo se 
       e' disponibile metto la foto all'interno del db    ---%>
<%-----------------------------------------------------------%>

     <c:choose>
            <c:when test="${foto_disponibile1}">
                <sql:param value="foto1scheda${id_scheda}.jpg"/>
            </c:when>
            <c:otherwise>
                <sql:param value=""/>
            </c:otherwise>
  	</c:choose>
     <c:choose>
            <c:when test="${foto_disponibile2}">
                <sql:param value="foto2scheda${id_scheda}.jpg"/>
            </c:when>
            <c:otherwise>
                <sql:param value=""/>
            </c:otherwise>
  	</c:choose>
     <c:choose>
            <c:when test="${foto_disponibile3}">
                <sql:param value="foto3scheda${id_scheda}.jpg"/>
            </c:when>
            <c:otherwise>
                <sql:param value=""/>
            </c:otherwise>
  	</c:choose>
</sql:update>


 
</c:otherwise>
</c:choose>




<%--------------------------------------------------------------------------%>
<%---- MESSAGGIO CHE STAMPO QUANDO LA SCHEDA VIENE SALVATA CON SUCCESSO ----%>
<%--------------------------------------------------------------------------%>
<c:set var="scheda_salvata" scope="request">Il salvataggio della scheda e' avvenuto con successo!</c:set>
<jsp:forward page="gestione_prod.jsp"/>