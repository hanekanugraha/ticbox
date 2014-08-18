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
    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
    <link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
    <link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">

    <link rel="stylesheet" href="${resource(dir: 'frameworks/jquery-ui-1.10.2/css/smoothness', file: 'jquery-ui-1.10.2.custom.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'frameworks/bootstrap/css', file: 'bootstrap.min.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'custom.css')}" type="text/css">

    <style type="text/css">

    </style>

    %{--<link rel="stylesheet" href="${resource(dir: 'frameworks/bootstrap/css', file: 'bootstrap-responsive.css')}" type="text/css">--}%

    <script type="text/javascript" src="${resource(dir: 'frameworks/jquery-ui-1.10.2/js', file: 'jquery-1.9.1.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'frameworks/jquery-ui-1.10.2/js', file: 'jquery-ui-1.10.2.custom.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'frameworks/bootstrap/js', file: 'bootstrap.min.js')}"></script>

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
                <ul class="nav navbar-nav tick">
                    <li>
                        <a href="${request.contextPath}/">Home</a>
                    </li>
                    <li><a>How It Works</a></li>
                    <li><a>Pricing</a></li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">About <b class="caret"></b></a>
                        <ul class="dropdown-menu">
                            <li>
                                <a href="#">About Us</a>
                            </li>
                            <li>
                                <a href="#">Blog</a>
                            </li>
                        </ul>
                    </li>
                </ul>

                <ul class="nav navbar-nav navbar-right">
                    <shiro:notAuthenticated>
                        <li><g:link controller="auth" action="login">Register | Login</g:link></li>
                        <li>
                            <g:link class="dropdown-toggle" data-toggle="dropdown">
                                <span>
                                    <g:message code="app.language.label"/>
                                    <b class="caret"></b>
                                </span>
                            </g:link>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                                <li role="presentation">
                                    <a href="${request.forwardURI }?lang=en"> <g:message code="app.language.english"/></a>
                                </li>
                                <li role="presentation">
                                    <a href="${request.forwardURI }?lang=in"> <g:message code="app.language.indonesia"/></a>
                                </li>
                            </ul>
                        </li>
                    </shiro:notAuthenticated>
                    <shiro:authenticated>
                    %{--INBOX--}%
                        <li class="dropdown">
                            <g:link class="dropdown-toggle" data-toggle="dropdown">
                                <span id="inbox" class="glyphicon glyphicon-envelope" data-toggle="tooltip" title="Inbox">
                                </span>
                                <g:if test="${ticbox.UserMessage.findAllByToUsernameAndIsRead(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size() > 0}">
                                    <span class="badge">
                                        ${ticbox.UserMessage.findAllByToUsernameAndIsRead(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size()}
                                    </span>
                                </g:if>
                            </g:link>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                                <li role="presentation">
                                    <b style="padding: 0 20px">Inbox</b>
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
                                        <a style="color:grey;">You have ... Inbox</a>
                                    </li>
                                </g:else>
                                <li role="presentation">
                                    <g:link controller="userMessage" action="createMessage" title="Create Message" >Create Message</g:link>
                                </li>
                                <li role="presentation">
                                    <g:link controller="userMessage" action="oldMessage" title="Old Message" >Old Message</g:link>
                                </li>
                            </ul>
                        </li>
                    %{--NOTIFICATION--}%
                        <li class="dropdown">
                            <g:link class="dropdown-toggle" data-toggle="dropdown" style="padding-right: 5px">
                                <span id="notif" class="glyphicon glyphicon-bullhorn" data-toggle="tooltip" title="Notification"></span>
                                <g:if test="${ticbox.UserNotification.findAllByUsernameAndIsNoticed(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size() > 0}">
                                    <span class="badge">
                                        ${ticbox.UserNotification.findAllByUsernameAndIsNoticed(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size()}
                                    </span>
                                </g:if>
                            </g:link>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                                <li role="presentation">
                                    <b style="padding: 0 20px">Notifications</b>
                                </li>
                                <li role="presentation" class="divider" style="margin: 3px 0 5px"></li>
                                <g:if test="${ticbox.UserNotification.findAllByUsernameAndIsNoticed(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size() > 0}">
                                    <g:each in="${ticbox.UserNotification.findAllByUsernameAndIsNoticed(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false)}" var="notification">
                                        <li role="presentation">
                                            <g:link controller="userNotification" title="${notification.title}" params="[code: notification.code]">${notification.title}</g:link>
                                        </li>
                                    </g:each>
                                </g:if>
                                <g:else>
                                    <li role="presentation">
                                        <a style="color:grey;">You have ${ticbox.UserNotification.findAllByUsernameAndIsNoticed(SecurityUtils.getSubject().getPrincipals().oneByType(String.class), false).size()} Notifications</a>
                                    </li>
                                </g:else>
                            </ul>
                        </li>
                    %{--ACCOUNT SPECIFIC--}%
                        <li class="dropdown">
                            <g:link controller="respondent" action="index" class="dropdown-toggle" data-toggle="dropdown">
                                ${SecurityUtils.getSubject().getPrincipals().oneByType(String.class)}
                                <b class="caret"></b>
                            </g:link>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                                <li role="presentation">
                                    <a href="${request.contextPath}/admin/surveys"><span class="glyphicon glyphicon-home"></span> Admin Dashboard</a>
                                </li>
                                <li role="presentation" class="divider"></li>
                                <li role="presentation">
                                    <a href="${request.contextPath}/admin/index"><span class="glyphicon glyphicon-home"></span> Users</a>
                                </li>
                                <li role="presentation" class="divider"></li>
                                <li role="presentation">
                                    <a>Help</a>
                                </li>
                                <li role="presentation">
                                    <a>Report a Problem</a>
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
                                    <a href="${request.forwardURI }?lang=en"> <g:message code="app.language.english"/></a>
                                </li>
                                <li role="presentation">
                                    <a href="${request.forwardURI }?lang=in"> <g:message code="app.language.indonesia"/></a>
                                </li>
                            </ul>
                        </li>
                    %{--LOGOUT BUTTON--}%
                        <li>
                            <g:link controller="auth" action="signOut">
                                <span id="log-out-btn" class="glyphicon glyphicon-log-out" data-toggle="tooltip"
                                      title="Logout">
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
    <%--
        NAVBAR.END
    --%>

    <div class="container" id="page-outer">
        <div id="wrapper-effect" class="wrapper grey">

            <g:if test="${flash.error}">
                <div class="alert alert-error" style="display: block">${flash.error}</div>
            </g:if>
            <g:if test="${flash.message}">
                <div class="alert alert-success" style="display: block">${flash.message}</div>
            </g:if>

            <g:layoutBody/>
        </div>
    </div>

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
                format : '<g:message code="app.date.format.js" default="dd/mm/yy"/>'
            });

        });

    </script>

</body>
</html>
