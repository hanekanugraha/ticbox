<%@ page import="org.apache.shiro.SecurityUtils" %>
<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title><g:layoutTitle default="TicBOX"/></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="${resource(dir: 'images/ticbox', file: 'ticbox-favicon.png')}" type="image/png">
    <link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
    <link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">

    <link rel="stylesheet" href="${resource(dir: 'frameworks/jquery-ui-1.10.2/css/smoothness', file: 'jquery-ui-1.10.2.custom.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'frameworks/bootstrap/css', file: 'bootstrap.min.css')}" type="text/css">
    %{--<link rel="stylesheet" href="${resource(dir: 'frameworks/bootstrap/css', file: 'bootstrap-responsive.css')}" type="text/css">--}%
    %{--<link rel="stylesheet" href="${resource(dir: 'css', file: 'app.css')}" type="text/css">--}%

    <script type="text/javascript" src="${resource(dir: 'frameworks/jquery-ui-1.10.2/js', file: 'jquery-1.9.1.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'frameworks/jquery-ui-1.10.2/js', file: 'jquery-ui-1.10.2.custom.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'frameworks/bootstrap/js', file: 'bootstrap.min.js')}"></script>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'custom.css')}" type="text/css">

    <g:layoutHead/>
    <r:layoutResources />

</head>
<body>
    <%--
        NAVBAR
    --%>
    <div class="navbar navbar-default">
        <div class="container">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand ticbox-logo" href="${request.contextPath}/"></a>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="navbar-collapse collapse">
                <ul class="nav navbar-nav">
                    <li>
                        <a href="${request.contextPath}/"><g:message code="default.home.label"/></a>
                    </li>
                    <li>
                        <a href="${request.contextPath}/howItsWork/"><g:message code="default.howitworks.label"/></a>
                    </li>
                </ul>

                <ul class="nav navbar-nav navbar-right">
                    <shiro:notAuthenticated>
                        <li><g:link controller="auth" action="login"><g:message code="default.login.label"/></g:link></li>
                        <li>
                            <g:link class="dropdown-toggle" data-toggle="dropdown">
                                <span>
                                    <g:message code="app.language.label"/>
                                    <b class="caret"></b>
                                </span>
                            </g:link>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                                <li role="presentation">
                                    <a href="${request.forwardURI}?${request.queryString != null ? request.queryString.replaceAll('(?i)&?lang=.*', '') + (request.queryString.replaceAll('(?i)&?lang=.*', '').empty ? '' : '&') : ''}lang=en"> <g:message code="app.language.english"/></a>
                                </li>
                                <li role="presentation">
                                    <a href="${request.forwardURI}?${request.queryString != null ? request.queryString.replaceAll('(?i)&?lang=.*', '') + (request.queryString.replaceAll('(?i)&?lang=.*', '').empty ? '' : '&') : ''}lang=in"> <g:message code="app.language.indonesia"/></a>
                                </li>
                            </ul>
                        </li>
                    </shiro:notAuthenticated>
                    <shiro:authenticated>
                        %{--INBOX--}%
                        <li class="dropdown">
                            <g:link class="dropdown-toggle" data-toggle="dropdown">
                                <span id="inbox" class="glyphicon glyphicon-envelope" data-toggle="tooltip" title=<g:message code="default.inbox.label"/>>
                                </span>
                                <g:if test="${ticbox.UserMessage.findAllByUsernameAndIsRead(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size() > 0}">
                                    <span class="badge">
                                        ${ticbox.UserMessage.findAllByUsernameAndIsRead(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size()}
                                    </span>
                                </g:if>
                            </g:link>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                                <li role="presentation">
                                    <b style="padding: 0 20px"><g:message code="default.inbox.label"/></b>
                                </li>
                                <li role="presentation" class="divider" style="margin: 3px 0 5px"></li>
                                <g:if test="${ticbox.UserMessage.findAllByToUsernameAndIsRead(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size() > 0}">
                                    <g:each in="${ticbox.UserMessage.findAllByToUsernameAndIsRead(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false)}" var="inbox">
                                        <li role="presentation">
                                            <g:link controller="userMessage" title="${inbox.subject}" params="[code: inbox.id]">${inbox.subject}</g:link>
                                        </li>
                                    </g:each>
                                </g:if>
                                <g:else>
                                    <li role="presentation">
                                        <a style="color:grey;"><g:message code="default.youhave.label"/> ... <g:message code="default.inbox.label"/></a>
                                    </li>
                                </g:else>
                                <li role="presentation">
                                    <g:link controller="userMessage" action="createMessage" title="Create Message" ><g:message code="default.createmessage.label"/></g:link>
                                </li>
                                <li role="presentation">
                                    <g:link controller="userMessage" action="oldMessage" title="Old Message" ><g:message code="default.oldmessage.label"/></g:link>
                                </li>
                            </ul>
                        </li>
                        %{--NOTIFICATION--}%
                        <li class="dropdown">
                            <g:link class="dropdown-toggle" data-toggle="dropdown">
                                <span id="notif" class="glyphicon glyphicon-bullhorn" data-toggle="tooltip" title=<g:message code="default.notifications.label"/>></span>
                                <g:if test="${ticbox.UserNotification.findAllByUsernameAndIsNoticed(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size() > 0}">
                                    <span class="badge">
                                        ${ticbox.UserNotification.findAllByUsernameAndIsNoticed(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size()}
                                    </span>
                                </g:if>
                            </g:link>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                                <li role="presentation">
                                    <b style="padding: 0 20px"><g:message code="default.notifications.label"/></b>
                                </li>
                                <li role="presentation" class="divider" style="margin: 3px 0 5px"></li>
                                <g:if test="${ticbox.UserNotification.findAllByUsernameAndIsNoticed(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size() > 0}">
                                    <g:each in="${ticbox.UserNotification.findAllByUsernameAndIsNoticed(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false)}" var="notification">
                                        <li role="presentation">
                                            <g:link controller="userNotification" title="${notification.title}" params="[code: notification.code, notif_id: notification.id]">${notification.title}</g:link>
                                        </li>
                                    </g:each>
                                </g:if>
                                <g:else>
                                    <li role="presentation">
                                        <a style="color:grey;"><g:message code="default.youhave.label"/> ${ticbox.UserNotification.findAllByUsernameAndIsNoticed(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size()} <g:message code="default.notifications.label"/></a>
                                    </li>
                                </g:else>
                            </ul>
                        </li>
                        %{--ACCOUNT SPECIFIC--}%
                        <li class="dropdown">
                            <g:link controller="respondent" action="index" class="dropdown-toggle" data-toggle="dropdown">
                                <span>
                                    ${SecurityUtils.getSubject().getPrincipals().oneByType(String.class)}
                                    %{--<g:if test="${ticbox.UserNotification.findAllByUsernameAndIsNoticed(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size() > 0}">--}%
                                        %{--<span class="badge" style="background-color: darkgoldenrod; vertical-align: top; font-size: 10px">--}%
                                        %{--${ticbox.UserNotification.findAllByUsernameAndIsNoticed(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size()}--}%
                                        %{--</span>--}%
                                    %{--</g:if>--}%
                                <b class="caret"></b>
                                </span>
                            </g:link>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                                %{--<g:if test="${ticbox.UserNotification.findAllByUsernameAndIsNoticed(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size() > 0}">--}%
                                    %{--<g:each in="${ticbox.UserNotification.findAllByUsernameAndIsNoticed(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false)}" var="notification">--}%
                                        %{--<li role="presentation">--}%
                                            %{--<g:link controller="userNotification" title="${notification.title}" params="[code: notification.code]">${notification.title}</g:link>--}%
                                        %{--</li>--}%
                                    %{--</g:each>--}%
                                %{--</g:if>--}%
                                %{--<g:else>--}%
                                    %{--<li role="presentation">--}%
                                        %{--<a style="color:grey; font-size: 10px">You have ${ticbox.UserNotification.findAllByUsernameAndIsNoticed(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size()} Notifications</a>--}%
                                    %{--</li>--}%
                                %{--</g:else>--}%
                                <li role="presentation">
                                    <a href="${request.contextPath}/respondent"><span class="glyphicon glyphicon-star"></span> <g:message code="default.dashboard.label"/></a>
                                </li>

                                <li role="presentation" class="divider"></li>
                                <li role="presentation">
                                    <a><g:message code="default.help.label"/></a>
                                </li>
                                <li role="presentation">
                                    <a><g:message code="default.reportproblem.label"/></a>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <g:link class="dropdown-toggle" data-toggle="dropdown">
                                <span>
                                    <g:message code="app.language.label"/>
                                    <b class="caret"></b>
                                </span>
                            </g:link>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                                <li role="presentation">
                                    <a href="${request.forwardURI}?${request.queryString != null ? request.queryString.replaceAll('(?i)&?lang=.*', '') + (request.queryString.replaceAll('(?i)&?lang=.*', '').empty ? '' : '&') : ''}lang=en"> <g:message code="app.language.english"/></a>
                                </li>
                                <li role="presentation">
                                    <a href="${request.forwardURI}?${request.queryString != null ? request.queryString.replaceAll('(?i)&?lang=.*', '') + (request.queryString.replaceAll('(?i)&?lang=.*', '').empty ? '' : '&') : ''}lang=in"> <g:message code="app.language.indonesia"/></a>
                                </li>
                            </ul>
                        </li>
                        %{--LOGOUT BUTTON--}%
                        <li>
                            <g:link controller="auth" action="signOut">
                                <span id="log-out-btn" class="glyphicon glyphicon-log-out" data-toggle="tooltip"
                                      title=<g:message code="app.signout.label"/>>
                                </span>
                            </g:link>
                        </li>
                    </shiro:authenticated>
                </ul>
            </div>
        </div>
        <div class="container">
            <div style="border-bottom: solid 1px #E7E7E7;"></div>
        </div>
    </div>

    <div id="page-outer" class="container">
        <div id="wrapper-effect" class="">
   			<div id="flashdiv">
	            <g:if test="${flash.error}">
	                <div class="alert alert-danger" style="display: block">${flash.error}</div>
	            </g:if>
	            <g:if test="${flash.message}">
	                <div class="alert alert-success" style="display: block">${flash.message}</div>
	            </g:if>
            </div>

			<div id="flashdiv">
	            <g:if test="${flash.error}">
	                <div class="alert alert-danger" style="display: block">${flash.error}</div>
	            </g:if>
	            <g:if test="${flash.message}">
	                <div class="alert alert-success" style="display: block">${flash.message}</div>
	            </g:if>
            </div>

            <div class="row">
                <div id="menuNavPanel" class="col-sm-3" style="margin-bottom: 10px;">

                    <div id="respondentProfileAccordion" class="panel-group" style="margin-bottom: 10px;">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <div class="media">
                                    <div class="col-xs-5" style="padding-left: 0">
                                        <g:if test="${respondent.pic}">
                                            <img id="sidebarPic" class="img-thumbnail img-responsive profile-pic" src="${g.createLink(action: 'viewImage', params: [respondentId: respondent.id])}"/>
                                        </g:if>
                                        <g:else>
                                            <img id="sidebarPic" class="img-thumbnail img-responsive profile-pic" src="${g.resource(dir: 'images/ticbox', file: 'anonymous.png')}"/>
                                        </g:else>
                                    </div>
                                    <div class="media-body col-xs-7" style="padding-left: 0;">
                                        <a data-toggle="collapse" data-parent="#respondentProfileAccordion" href="#respondentProfileContainer">
                                            <b class="fullName">${respondent?.username}</b>
                                        </a>
                                        <g:link class="metadata" action="profileForm"><g:message code="app.viewprofile.title"/></g:link>
                                    </div>
                                </div>
                            </div>
                            <div id="respondentProfileContainer" class="panel-collapse collapse in">
                                <div class="panel-body" style="padding: 0 12px;">
                                    <div class="row profileStats">
                                        <div class="col-xs-6 stats">
                                            <div><strong>${respondent?.respondentProfile?.gold}</strong></div>
                                            <div class="gold"><b><g:message code="point.gold.label"/></b></div>
                                        </div>
                                        <div class="col-xs-6 stats leftBordered">
                                            <div><strong>${surveyJoined}</strong></div>
                                            <div><b><g:message code="app.surveyjoined.label"/></b></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="respondentNavAccordion" class="panel-group">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <div class="panel-title">
                                    <a data-toggle="collapse" data-parent="#respondentNavAccordion" href="#respondentNavContainer">
                                        <g:message code="app.dashboard.title"/>
                                    </a>
                                </div>
                            </div>
                            <div id="respondentNavContainer" class="panel-collapse collapse in">
                                <div class="panel-body" style="padding-left: 12px;">
                                    <ul class="nav nav-pills nav-stacked">
                                        <li class="index">
                                            <g:link action="index"><g:message code="resp.surveylist.label"/></g:link>
                                        </li>
                                        <li class="profileForm">
                                            <g:link action="profileForm"><g:message code="resp.profile.label"/></g:link>
                                        </li>
                                        <li class="redeemGold">
                                            <g:link action="redeemGold"><g:message code="resp.redeemgold.label"/></g:link>
                                        </li>
                                        <li class="redeemItems">
                                            <g:link action="redeemItems"><g:message code="resp.redeemitems.label"/></g:link>
                                        </li>
                                        <li class="goldHistory">
                                            <g:link action="goldHistory"><g:message code="resp.goldpointhist.label"/></g:link>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <div role="main" class="col-sm-9" id="contentPanel">
                    <div class="module">
                        <g:layoutBody/>
                    </div>
                </div>
            </div>

            %{--<footer>
                &copy; TicBOX 2013
            </footer>--}%
        </div>
    </div>
    <g:render template="/layouts/footer"></g:render>
%{--</div>--}%

    <div id="spinner" class="spinner" style="display:none;"><g:message code="spinner.alt" default="Loading&hellip;"/></div>

    <r:layoutResources />

    <script type="text/javascript">
        $('#log-out-btn').tooltip({'placement': 'bottom','content':'html'});
        $('#notif').tooltip({'placement': 'bottom','content':'html'});
        $('#inbox').tooltip({'placement': 'bottom','content':'html'});
        jQuery(function(){

            jQuery(".nav > li.${actionName}").addClass('active');

            jQuery('#menuNavPanel').append(jQuery('#menuNavPanelContent'));

            jQuery('.datePicker').datepicker({
                showAnim : 'slideDown',
                dateFormat : '<g:message code="app.date.format.js" default="dd/mm/yy"/>',
                changeMonth: true,
                changeYear: true,
                yearRange: 'c-60:c+10'
            });

        });

        function flashMessage(message, success) {
            $('#flashdiv').html('<div class="alert alert-' + (success ? 'success' : 'danger') + '" style="display: block">' + message + '</div>');
            $('html, body').animate({
                scrollTop: $("#flashdiv").offset().top
            }, 250);
            setTimeout(
    			function() {
    					$('#flashdiv').html('');
    				}, 3000);
        }
        
    </script>

</body>
</html>
