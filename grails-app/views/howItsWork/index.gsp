<%--
  Created by IntelliJ IDEA.
  User: firmanagustian
  Date: 5/18/15
  Time: 13:45
--%>


<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="ticbox"/>
    <title><g:message code="ticbox.howItWorks.title"/></title>
</head>
<body>


<div class="clearfix home-content module features" style="padding-bottom: 40px">
    <div>
        <div style="padding-left: 12px">
            <h3><g:message code="ticbox.howItWorks.ticboxsurveyor.label"/></h3>
            <h4>
                <g:message code="ticbox.howItWorks.ticboxsurveyor.content"/>
            </h4>
        </div>
        <div style="font-size: 14px; text-align: center;">
            <div class="col-sm-4">
                <span class="glyphicon glyphicon-user features-icon"></span>
                <g:message code="ticbox.howItWorks.ticboxsurveyor.user.label"/>
            </div>
            <div class="col-sm-4">
                <span class="glyphicon glyphicon-usd features-icon"></span>
                <g:message code="ticbox.howItWorks.ticboxsurveyor.price.label"/>
            </div>
            <div class="col-sm-4">
                <span class="glyphicon glyphicon-stats features-icon"></span>
                <g:message code="ticbox.howItWorks.ticboxsurveyor.result.label"/>
            </div>
        </div>
        %{--<div style="font-size: 14px; text-align: center;">--}%
            %{--<div class="col-sm-12" style="padding-left: 0">--}%
                %{--<a style="margin:0 0 5px 0" class="btn btn-green btn-lg" href="${g.createLink(controller: 'auth', action: 'registerSurveyor')}">--}%
                    %{--<span class="glyphicon glyphicon-user"></span> <g:message code="app.register.surveyor.label"/>--}%
                %{--</a>--}%
            %{--</div>--}%
        %{--</div>--}%
    </div>
</div>

<div class="clearfix home-content module features" style="padding-bottom: 40px">
    <div>
        <div style="padding-left: 12px">
            <h3><g:message code="ticbox.howItWorks.ticboxrespondent.label"/></h3>
            <h4>
                <g:message code="ticbox.howItWorks.ticboxrespondent.content"/>
            </h4>
        </div>
        <div style="font-size: 14px; text-align: center;">
            <div class="col-sm-2">
                <span class="glyphicon glyphicon-usd features-icon"></span>
                <g:message code="ticbox.howItWorks.ticboxrespondent.Paid.label"/>
            </div>
            <div class="col-sm-2">
                <span class="glyphicon glyphicon-phone features-icon"></span>
                <g:message code="ticbox.howItWorks.ticboxrespondent.everywhere.label"/>
            </div>
            <div class="col-sm-2">
                <span class="glyphicon glyphicon-eye-close features-icon"></span>
                <g:message code="ticbox.howItWorks.ticboxrespondent.save.label"/>
            </div>
            <div class="col-sm-2">
                <span class="glyphicon glyphicon-refresh features-icon"></span>
                <g:message code="ticbox.howItWorks.ticboxrespondent.Merchendise.label"/>
            </div>
            <div class="col-sm-2">
                <span class="glyphicon glyphicon-bullhorn features-icon"></span>
                <g:message code="ticbox.howItWorks.ticboxrespondent.future.label"/>
            </div>
            <div class="col-sm-2">
                <span class="glyphicon glyphicon-heart features-icon"></span>
                <g:message code="ticbox.howItWorks.ticboxrespondent.free.label"/>
            </div>
        </div>
    </div>
    %{--<div style="font-size: 14px; text-align: center;">--}%
        %{--<div class="col-sm-12" style="padding-left: 0">--}%
        %{--<a style="margin:0 0 5px 0" class="btn btn-lg btn-blue-trust" href="${g.createLink(controller: 'auth', action: 'registerRespondent')}">--}%
            %{--<span class="glyphicon glyphicon-user"></span> <g:message code="app.register.surveyor.label"/>--}%
        %{--</a>--}%
        %{--</div>--}%
    %{--</div>--}%
</div>

</body>
</html>