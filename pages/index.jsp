<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<html>
<head>


<%-----------------------------------%>
<%--- SE UTENTE NON E' LOGGATO  -----%>
<%-----------------------------------%>
 <c:if test="${empty user_userid}">
<%@ include file="top_nouser.jspf" %> 
</c:if>

<%-----------------------------------%>
<%-----  SE UTENTE  E' LOGGATO  -----%>
<%-----------------------------------%>
<c:if test="${not empty user_userid}">
<%@ include file="top_user.jspf" %> 
</c:if>
</head>


<body style="background-image: url(fotosfondo4.png); background-repeat:no-repeat; background-position:center; background-size:100% 100%;width:   100%;
height:  100%;background-color:transparent;">

<table align="center" border="0" width="90%" height="85%">
<tr height="60%"><td align="center" colspan="3"><img src="logoala1.png" width="25%"/></td></tr>
<tr height="40%"><td  align="center" colspan="3"><font color="#007171" size="5"><b>ALAMBICCUS S.R.L. GARANTISCE LA TRACCIABILITA' DEL PROCESSO DI CERTIFICAZIONE DEI TUOI PRODOTTI </br> REGISTRATI E POTRAI USUFRUIRE DEI NOSTRI SERVIZI! </b></font></td></tr>

    <td align="center" width="33%" height="30"> </br> </br>
          <a href="statistiche.jsp"><img src="statistiche11.png" title="STATISTICHE" width="20%" ></img></a>
          </br> </br>
    </td>
    <td align="center" width="33%" height="30"> </br> </br>
           <a href="contatti.jsp"><img src="contatti1.png" title="CONTATTI" width="20%"></img></a>
          </br></br>
    </td>
       <td align="center" width="33%" height="30"> </br> </br>
            <a href="info.jsp"><img src="info1.png" title="INFORMAZIONI" width="20%"></img></a>
           </br></br>
            
    </td>
</tr>

</table>
</body>
</html>