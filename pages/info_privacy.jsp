<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>


<%@ include file="top.jspf" %> 


<%--------------------------------------------------------------------------------------%>
<%------------------------------    COMANDO INDIETRO   ---------------------------------%>
<%--------------------------------------------------------------------------------------%>
       <td align="right" width="130" >

<%---------------------------------------------------------------------------%>
<%--- SE NON C'E' L' UTENTE COLLEGATO, TORNA INDIETRO ALLA  REGISTRAZIONE ---%>
<%---------------------------------------------------------------------------%>
       <c:if test="${empty user_userid}">
        <a href="registrazione.jsp"><img src="regi.png" title="RITORNA ALLA REGISTRAZIONE" style="width:60px;height:60px";> 
         </a> 
       </c:if>
<%---------------------------------------------------------------------------%>
<%---- SE C'E' UN UTENTE LOGGATO, TORNA INDIETRO ALLA PAGINA INFO -----------%>
<%---------------------------------------------------------------------------%>
      <a href="info.jsp"><img style="width:60px;height:60px" src="indietro.png"></a>    
  </td>


<%--------------------------------------------------------------------------------------%>
<%----------------------------    FRAMMENTO MIDDLE      --------------------------------%>
<%--------------------------------------------------------------------------------------%>      
<%@include file="middle.jspf"%>              
     

<table width="100%" border="0" cellspacing="0" cellpadding="2"bgcolor="#bbccdc">
<tr> <td align="center"> <img src="privacy.png" width="20%">
<p style="font-size:23px;font-weight:bold;color: #007171;">INFORMATIVA PRIVACY SUL TRATTAMENTO DEI DATI PERSONALI</p>

</br>
</td>
<tr><td> <p style="font-size:20px;font-style: italic;"><b>
La presente Informativa sulla privacy fornisce informazioni dettagliate sul modo in cui ALA S.R.L. tratta i dati personali dei propri utenti.</b>
</p>

<p style="font-size:15px;font-style: italic;">
I dati personali sono trattati in conformita' con il Regolamento UE in materia di protezione dei dati personali (Regolamento (UE) 2016/679 - GDPR) e altre leggi e regolamenti nazionali ed europei in materia di tutela della privacy.
</p>

<p style="font-size:15px;font-style: italic;">
<b>1. AMBITO DI APPLICAZIONE</b> </br>
La presente Informativa sulla privacy si applica a tutti i dati personali trattati da ALA S.R.L in qualita'  di controllore dei dati.
</br>
Nella misura in cui decide come e perche' i dati personali vengono elaborati, ALA S.R.L. agisce in qualita' di controllore dei dati per tali dati personali.
</p>

<p style="font-size:15px;font-style: italic;">
<b>2. FINALITA'</b> </br>
La presente Informativa sulla privacy mira a spiegare quali dati personali vengono trattati, le motivazioni e le modalita' del trattamento.
</p>

<p style="font-size:15px;font-style: italic;">
<b>1. TIPOLOGIE DI DATI PERSONALI</b> </br>
<p style="font-size:15px;font-style: italic;">
<b>1.1 UTENTI</b> </br>
ALA S.R.L. raccoglie ed elabora i dati personali in relazione ai propri utenti. Tali dati personali includono: dati personali quali il nome dell'utente, dettagli di contatto, quali indirizzo e numero di telefono; dettagli dei fascicoli personali inclusi, ad esempio, i termini e le condizioni di impiego, la formazione, le valutazioni delle performance, le promozioni, i piani di sviluppo personale, i dati comportamentali e disciplinari, l' ubicazione di lavoro, i dati salariali, dettagli sul percorso lavorativo/la candidatura, come la formazione e le esperienze lavorative; contenuti editoriali o giornalistici dati necessari per il pensionamento; infine, dati correlati alle performance, come i rating di gestione delle performance per i dirigenti e gli incrementi annuali delle retribuzioni dei dipendenti, i test psicometrici e altro ancora. L ' elenco precedente non e' esaustivo ma copre i dati personali piu' comuni raccolti, utilizzati e altrimenti trattati.

</br>

<b>1.2 CLIENTI </b> </br>
L ' azienda raccoglie ed elabora i dati personali in relazione a soggetti che sono entrati a far parte di ALA S.R.L. Tali dati personali includono: dati personali quali il nome, la qualifica, la posizione,l'unita'  aziendale (inclusi i dati di contatto raccolti a fini di formazione/verifica); dati di contatto quali l ' indirizzo e-mail, i numeri di telefono e l ' ubicazione di lavoro,partita IVA.
</p>

<p style="font-size:15px;font-style: italic;">
<b>2. DIRITTI INDIVIDUALI</b> </br>
I soggetti interessati godono di determinati diritti in base alla normativa sulla protezione dei dati.
</br> </br>
<b>2.1 Ispezione e accesso:</b> </br>
e' possibile richiedere un riepilogo e una copia dei propri dati personali.
</br></br>
<b>2.2 Correzione/aggiunta/rimozione:</b> </br>
qualora ritenga che i propri dati personali siano imprecisi o incompleti, il soggetto interessato ha il diritto di richiederne la correzione, modifica o eliminazione;
</br></br>
<b>2.3 Obiezione:</b> </br>
il soggetto interessato puo' opporsi al trattamento dei propri dati personali 
</br></br>
<b>2.4 Restrizione:</b> </br>
il soggetto interessato puo' chiedere di limitare il trattamento dei propri dati personali quando l ' accuratezza degli stessi e' messa in discussione, il trattamento e' illegale, il soggetto ritiene che ALA non abbia piu' bisogno dei dati personali o si oppone al trattamento;
</br></br>
<b>2.5 Automazione del processo decisionale:</b> </br>
se ALA S.R.. intraprende un processo decisionale automatico,che influisce in modo significativo sul soggetto interessato, questi ha il diritto di opporsi a tale decisione.
</br> </br>
<b>3. SICUREZZA</b> </br> </br>
<b>3.1 Misure di sicurezza</b> </br>
ALA S.R.L dispone di misure tecniche e organizzative per proteggere i dati personali dai casi di distruzione, perdita, modifica, divulgazione, acquisizione o accesso illegali o non autorizzati.
I dati personali sono archiviati in modo sicuro, tramite una serie di misure di sicurezza che comprendono, se del caso, misure fisiche come armadietti di archiviazione chiusi a chiave e varie misure IT.
</br> </br>
<b>3.2 Violazione dei dati personali</b> </br>
ALA gestira'  ogni violazione dei dati in conformita' con la procedura di segnalazione in caso di violazione dei dati personali. Per informazioni su come individuare e segnalare una violazione dei dati, fare riferimento alla nostra procedura di violazione dei dati personali.
</br></br>
<b>4. DIVULGAZIONE DI DATI PERSONALI</b> </br>
Di tanto in tanto, ALA puo' divulgare i dati personali a terzi o consentire a terzi di accedere ai dati personali trattati. Laddove stipuli accordi con terzi per il trattamento dei dati personali a proprio nome, la societa' garantisce che siano messe in atto opportune protezioni contrattuali per salvaguardarli.
</br>
</br>
<b>5. CONSERVAZIONE DEI DATI</b> </br>
ALA conserva i dati personali solo per il tempo ritenuto strettamente necessario per gli scopi per i quali vengono trattati. I dati personali sono conservati in conformita' con le leggi applicabili e le linee guida aziendali.
</br>
</br>
<b>6. RUOLI E RESPONSABILITA'</b> </br>
ALA e' responsabile del trattamento dei dati personali. L ' amministratore delegato di ALA e' responsabile della conformita' della societa' alla presente Informativa sulla privacy e designera' un punto di contatto primario in relazione (i) al trattamento dei dati personali di dipendenti ed ex dipendenti e contraenti della societa'; (ii) al trattamento dei dati personali dei referenti aziendali e (iii) alla salvaguardia della sicurezza e dell ' integrita' dei dati personali trattati dalla societa'.
</br>
</br>
<b>7. PROCEDURA DI GESTIONE DEI RECLAMI</b> </br>
E' possibile porre domande o presentare obiezioni in merito alla presente Informativa e/o al trattamento dei propri dati personali contattando [privacy@ala.it]. 

</p>


</td>
</tr>
</table>