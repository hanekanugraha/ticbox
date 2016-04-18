<%--
  Created by IntelliJ IDEA.
  User: firmanagustian
  Date: 4/13/16
  Time: 1:24 PM
--%>

<%@ page import="ticbox.Item; ticbox.User; org.apache.shiro.SecurityUtils" %>
<html>
<head>
    <meta name="layout" content="admin"/>
    <title><g:message code="ticbox.admin.redemptions.label"/></title>
    <style type="text/css">
    .fade-text {
        color: #bfbfbf;
        font-style: italic;
    }
    </style>
</head>
<body>
<h3><g:message code="admin.redemptionhistory.money.label"/></h3>

<br />

<table id="redemptionTable" class="table table-bordered table-striped">
    <thead>
    <tr>
        <th><g:message code="app.redemptiondate.label"/></th>
        <th><g:message code="app.name.title"/></th>
        <th><g:message code="app.amount.label"/></th>
        <th><g:message code="app.bankname.label"/></th>
        <th><g:message code="app.accountno.label"/></th>
        <th><g:message code="app.accountname.label"/></th>
        <th><g:message code="app.status.label"/></th>
        <th><g:message code="app.information.label"/></th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${redemptionRequestList}" var="redemption" status="status">
        <tr>
            <td>${redemption.dateCreated}</td>
            <td>${redemption.respondentUsername}</td>
            <td>${g.formatNumber(number: redemption.redemptionAmount, formatName: 'app.currency.format')}</td>
            <td>${redemption.bankName}</td>
            <td>${redemption.bankAccountNumber}</td>
            <td>${redemption.bankAccountName}</td>
            <td>${redemption.status}</td>
            <td>${redemption.info}</td>
        </tr>
    </g:each>
    </tbody>
</table>

<h3><g:message code="admin.redemptionhistory.items.label"/></h3>

<br />
<g:each in="${redemptionItemRequestList}" var="redemptionItem">
</g:each>
<table id="redemptionItemTable" class="table table-bordered table-striped">
    <thead>
    <tr>
        <th><g:message code="app.redemptiondate.label"/></th>
        <th><g:message code="app.name.title"/></th>
        <th><g:message code="app.goldamount.label"/></th>
        <th><g:message code="admin.items.label"/></th>
        <th><g:message code="app.status.label"/></th>
        <th><g:message code="app.information.label"/></th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${redemptionItemRequestList}" var="redemptionItem">
        <tr>
            <td>${redemptionItem.dateCreated}</td>
            <td>${redemptionItem.respondentUsername}</td>
            <td>${redemptionItem.goldAmount}</td>
            <td><g:each in="${redemptionItem.ITEMS}" var="item" status="status">
                ${Item.findById(item)?.itemName}
                ${Item.findById(item)?.gold}
                <br/>
            </g:each>
            </td>
            <td>${redemptionItem.status}</td>
            <td>${redemptionItem.info}</td>
        </tr>
    </g:each>
    </tbody>
</table>

</body>
</html>