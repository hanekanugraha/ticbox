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
            <h3><span class="title">Ticbox</span> Surveyor</h3>
            <h4>
                Ticbox is an Survey-Engine-Tools. Here's what makes life <span class="marroon">Easier</span> if you register as Surveyor :
            </h4>
        </div>
        <div style="font-size: 14px; text-align: center;">
            <div class="col-sm-4">
                <span class="glyphicon glyphicon-user features-icon"></span>
                Everyone can access Ticbox survey with our Intuitive UI for <b>easy survey creation</b>. You don’t have to be a researcher to take advantage of it. Doesn’t matter if you are <b>student</b>, <b>entrepreneurs</b> or <b>big company owner.</b>
            </div>
            <div class="col-sm-4">
                <span class="glyphicon glyphicon-usd features-icon"></span>
                You don’t have to plan and budget it in advance. You can get charged <b>Only</b> for what you need. You can even use it for <b>FREE</b>
            </div>
            <div class="col-sm-4">
                <span class="glyphicon glyphicon-stats features-icon"></span>
                You don’t have to have more than a few days to get the actionable insights. Ticbox allows you to <b>‘slice and dice’</b> the data on fly and discover the actionable insight <b>faster</b>.
            </div>
        </div>
        <div style="font-size: 14px; text-align: center;">
            <div class="col-sm-12" style="padding-left: 0">
                <a style="margin:0 0 5px 0" class="btn btn-green btn-lg" href="${g.createLink(controller: 'auth', action: 'registerSurveyor')}">
                    <span class="glyphicon glyphicon-user"></span> Register as Surveyor
                </a>
            </div>
        </div>
    </div>
</div>

<div class="clearfix home-content module features" style="padding-bottom: 40px">
    <div>
        <div style="padding-left: 12px">
            <h3><span class="title">Ticbox</span> Respondent</h3>
            <h4>
                In here you can make your spare time more <span class="marroon">FUN</span>, <span class="marroon">Contribute</span>, and <span class="marroon">Earn Money</span> at the same time :
            </h4>
        </div>
        <div style="font-size: 14px; text-align: center;">
            <div class="col-sm-2">
                <span class="glyphicon glyphicon-usd features-icon"></span>
                It is not a charity. You will get <b>Paid</b>.
            </div>
            <div class="col-sm-2">
                <span class="glyphicon glyphicon-eye-close features-icon"></span>
                Your credential data is <b>save</b>.
            </div>
            <div class="col-sm-2">
                <span class="glyphicon glyphicon-phone features-icon"></span>
                You can do it <b>anywhere</b> and <b>everywhere</b>.
            </div>
            <div class="col-sm-2">
                <span class="glyphicon glyphicon-refresh features-icon"></span>
                Redeem your point into <b>Smartphone</b>, <b>Merchendise</b>, <b>etc.</b>
            </div>
            <div class="col-sm-2">
                <span class="glyphicon glyphicon-bullhorn features-icon"></span>
                Contribute to <b>sociaty</b>. Be part of a better <b>future</b>.
            </div>
            <div class="col-sm-2">
                <span class="glyphicon glyphicon-heart features-icon"></span>
                And the best part is...it's <b>FREE</b>.
            </div>
        </div>
    </div>
    <div style="font-size: 14px; text-align: center;">
        <div class="col-sm-12" style="padding-left: 0">
        <a style="margin:0 0 5px 0" class="btn btn-lg btn-blue-trust" href="${g.createLink(controller: 'auth', action: 'registerRespondent')}">
            <span class="glyphicon glyphicon-user"></span> Register as Respondent
        </a>
        </div>
    </div>
</div>

</body>
</html>