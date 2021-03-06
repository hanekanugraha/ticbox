<%@ page import="ticbox.RespondentGoldHistory" %>
<html>
<head>
    <meta name="layout" content="respondent"/>
    <title><g:message code="goldhistory.title"/></title>
    <style type="text/css">
    </style>
</head>
<body>
    <div id="goldHistoryHeader" class="module-header">
        <div class="title"><g:message code="goldhistory.title"/></div>
    </div>
    <div id="goldHistory" class="module-content">
        <g:if test="${goldHistory != null && goldHistory.size() > 0}">
            <table class="table table-bordered">
               <thead>
                    <tr>
                        <th><g:message code="app.date.label"/></th>
                        <th><g:message code="app.type.label"/></th>
                        <th><g:message code="app.description.label"/></th>
                        <th><g:message code="app.amount.label"/></th>
                        <th><g:message code="app.status.label"/></th>
                    </tr>
               </thead>
               <tbody>
                <g:each in="${goldHistory}" var="history">
                    <tr class="<g:if test='${RespondentGoldHistory.TYPES.INCOME_SURVEY.equals(history.type) || RespondentGoldHistory.TYPES.INCOME_REFERENCE.equals(history.type)}'>info</g:if><g:else>warning</g:else>">
                        <td class="span2">${history.date}</td>
                        <td class="span2">${history.typeDisplay()}</td>
                        <td class="span5">${history.description}</td>
                        <td class="span2">${history.amount}</td>
                        <td class="span3">${history.statusDisplay()}</td>
                    </tr>
                </g:each>
               </tbody>
            </table>
        </g:if>
        <g:else>
            <div class="module-message"><g:message code="goldhistory.nohistory.label"/> </div>
        </g:else>
    </div>
</body>
</html>