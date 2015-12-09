<%@ page import="org.apache.shiro.SecurityUtils; ticbox.ProfileItem; ticbox.Survey" %>
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
    <link rel="stylesheet" href="${resource(dir: 'frameworks/prettyCheckable', file: 'prettyCheckable.css')}" type="text/css">
    %{--<link rel="stylesheet" href="${resource(dir: 'css', file: 'app.css')}" type="text/css">--}%
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'custom.css')}" type="text/css">

    <style type="text/css">
        textarea, input[type=text] {
            background-color: #f5f5f5;
        }

        textarea:focus, input[type=text]:focus {
            background-color: #ffffff;
        }

        @media (max-width: 980px) {
            /* Enable use of floated navbar text */
            .navbar-text.pull-right {
                float: none;
                padding-left: 5px;
                padding-right: 5px;
            }
        }

        #menuNavPanel .module .side-panel {
            width: 100%;
            margin: 15px 0 10px 0;
        }

        #menuNavPanel .module .side-panel .header {
            color: #7F9B09; /*#bad33c;*/
            font-size: x-large;
            /*margin-bottom: 10px;*/
        }

        #menuNavPanel .module hr{
            margin: 0;
        }

        .preview-item-even {
            background-color: #ececec;
        }
    </style>

    %{--<link rel="stylesheet" href="${resource(dir: 'frameworks/bootstrap/css', file: 'bootstrap-responsive.css')}" type="text/css">--}%

    <script type="text/javascript" src="${resource(dir: 'frameworks/jquery-ui-1.10.2/js', file: 'jquery-1.9.1.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'frameworks/jquery-ui-1.10.2/js', file: 'jquery-ui-1.10.2.custom.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'frameworks/bootstrap/js', file: 'bootstrap.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'frameworks/prettyCheckable', file: 'prettyCheckable.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'loader.js')}"></script>

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
                        <a href="${request.contextPath}/survey"><span class="glyphicon glyphicon-star"></span><g:message code="default.dashboard.label"/></a>
                    </li>

                </ul>

                <ul class="nav navbar-nav navbar-right">
                    <shiro:notAuthenticated>
                        <li><g:link controller="auth" action="login"><g:message code="default.registerlogin.label"/></g:link></li>
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
                                <span id="inbox" class="glyphicon glyphicon-envelope" data-toggle="tooltip" title=<g:message code="default.inbox.label"/>
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
                                            <g:link controller="userNotification" title="${notification.title}" params="[code: notification.code]">${notification.title}</g:link>
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
                                    <b class="caret"></b>
                                </span>
                            </g:link>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                                <li role="presentation">
                                    <a href="${request.contextPath}/survey"><span class="glyphicon glyphicon-star"></span> <g:message code="default.dashboard.label"/></a>
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
            <div class="row">
                <div id="menuNavPanel" class="col-sm-3" style="margin-bottom: 10px;">
                    <div id="surveyorProfileAccordion" class="panel-group" style="margin-bottom: 10px;">
                        <div class="panel panel-default panel-dashboard">
                            <div id="dashboardTitle" class="dashboard-title">
                                <div class="panel-body dashboard-body">
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <strong style="display: inline"></span> <g:message code="app.dashboard.title"/></strong>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-heading dashboard-heading">
                                <div class="media">
                                    <div class="col-xs-5" style="padding-left: 0">
                                        <g:if test="${surveyor.pic}">
                                            <img id="sidebarPic" class="img-thumbnail img-responsive profile-pic" src="data:image;base64,${surveyor.pic}"/>
                                        </g:if>
                                        <g:else>
                                            <img id="sidebarPic" class="img-thumbnail img-responsive profile-pic" src="${g.resource(dir: 'images/ticbox', file: 'anonymous.png')}"/>
                                        </g:else>
                                    </div>
                                    <div class="media-body col-xs-7" style="padding-left: 0;">
                                        <a data-toggle="collapse" data-parent="#respondentProfileAccordion" href="#surveyorProfileContainer">
                                            <b class="fullName">${surveyor?.username}</b>
                                        </a>
                                        <div style="color: grey; font-size: 12px; text-transform: uppercase">${surveyorProfile?.companyName}</div>
                                        <g:link class="metadata" action="profileForm"><g:message code="app.viewprofile.title"/></g:link>
                                    </div>
                                </div>
                            </div>
                            <div id="surveyorProfileContainer" class="panel-collapse collapse in" style="border-left: 1px solid #ddd; border-right: 1px solid #ddd; border-left: 1px solid #ddd; border-bottom: 1px solid #ddd; border-radius: 0 0 6px 6px">
                                <div class="panel-body" style="padding: 0 12px; border-top: 0 !important">
                                    <div class="row profileStats">
                                        <div class="col-xs-3 stats">
                                            <div><strong>${countDraft}</strong></div>
                                            <div><g:message code="app.draft.status"/></div>
                                        </div>
                                        <div class="col-xs-5 stats leftBordered">
                                            <div><strong>${countInProgress}</strong></div>
                                            <div style="color: #7F9B09"><g:message code="app.inprogress.status"/></div>
                                        </div>
                                        <%--div class="col-xs-3 stats leftBordered">
                                            <div><strong>${countSubmitted}</strong></div>
                                            <div >Submitted</div>
                                        </div--%>
                                        <div class="col-xs-3 stats leftBordered">
                                            <div><strong>${countCompleted}</strong></div>
                                            <div class="trust"><g:message code="app.completed.status"/></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body" style="padding: 0 12px;">
                                    <div class="row profileStats">
                                        <div class="col-xs-12 stats">
                                            <strong style="display: inline">3,500,000</strong>
                                            <span class="gold" style="margin-left: 5px"><g:message code="app.creditsavailable.title"/></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    %{-- ################# SURVEY INFO ACCORDION ################# --}%
                    <div id="surveyInfoAccordion" class="panel-group" style="margin-bottom: 10px;">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <div class="panel-title">
                                    <a data-toggle="collapse" data-parent="#surveyInfoAccordion" href="#surveyInfoContainer">
                                        <g:message code="app.surveyinfo.title"/> <b class="caret"></b>
                                    </a>
                                </div>
                            </div>
                            <div id="surveyInfoContainer" class="panel-collapse collapse in">
                                <div class="panel-body" style="padding-left: 15px;padding-right: 15px;">
                                    <div class="row" style="line-height: 20px;">
                                        <div class="col-xs-12">
                                            <div style="border-bottom: 1px dotted lightgrey; border-top: 1px dotted lightgrey">
                                                <g:message code="app.name.title"/> : ${survey?.name}
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row" style="line-height: 20px;">
                                        <div class="col-xs-12">
                                            <div style="border-bottom: 1px dotted lightgrey">
                                                <g:message code="app.numrespondent.title"/> : 100
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row" style="line-height: 20px">
                                        <div class="col-xs-12">
                                            <g:message code="app.itinerarydetails.title"/> :
                                            <div style="border-bottom: 1px dotted lightgrey; border-top: 1px dotted lightgrey">
                                                    <ul style="font-size: 12px; margin-bottom: 0">
                                                    <li>100 x $0 = $0</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel-body" style="padding-left: 12px;">
                                    <div class="row" style="line-height: 20px">
                                        <div class="col-xs-12">
                                            <form class="form-horizontal" role="form">
                                                <div class="form-group" style="margin-bottom: 0">
                                                    <label for="total" class="col-sm-2 control-label"><g:message code="app.total.title"/></label>
                                                    <div class="col-sm-10">
                                                        <input id="total" class="form-control" type="text" value="$ 0" readonly="true" style="width: auto; background-color: #d4dcb4; margin: 0; border-radius: 20px; font-weight: bold; color: darkgoldenrod">
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div role="main" class="col-sm-9" id="contentPanel">
                    %{--<div class="module">--}%
                        <g:layoutBody/>
                    %{--</div>--}%

                </div>
            </div>

                %{--<div id="mainContentPanel" class="rightPanel">--}%
                    %{--<g:layoutBody/>--}%
                %{--</div>--}%
            %{--</div>--}%

            %{--<footer>
                &copy; TicBOX 2013
            </footer>--}%
        </div>
    </div>
    <g:render template="/layouts/footer"></g:render>
%{--</div>--}%

<r:layoutResources />

<script type="text/javascript">

    var surveySummary;

    jQuery(function(){
        $('#log-out-btn').tooltip({'placement': 'bottom','content':'html'});
        $('#notif').tooltip({'placement': 'bottom','content':'html'});
        $('#inbox').tooltip({'placement': 'bottom','content':'html'});

        jQuery('input.prettyChk').prettyCheckable();

        jQuery(".nav > li.${controllerName}").addClass('active');

        jQuery('button.link').click(function(){
            var href = jQuery(this).attr('href');
            if(href){
                window.location.href = href;
            }
        });

        jQuery('button.submit-redirect').click(function(){

            var form = jQuery('<form method="post"></form>').attr('action', jQuery(this).attr('href')).hide();

            jQuery("[param-of='"+jQuery(this).attr('id')+"']").each(function(){
                form.append(jQuery('<input type="hidden">').attr('name', jQuery(this).attr('name')).val(jQuery(this).val()));
            });

            form.appendTo('body').submit();

        });

        //jQuery('#menuNavPanel .survey-summary').before(jQuery('#menuNavPanelContent'));
        jQuery('#menuNavPanel').append(jQuery('#menuNavPanelContent').contents());

        jQuery('.datePicker').datepicker({
            showAnim : 'slideDown',
            format : '<g:message code="app.date.format.js" default="dd/mm/yy"/>'
        });

        jQuery('.enableTooltip').tooltip({
            selector: "button[data-toggle=tooltip]"
        });

    });



</script>

</body>
</html>
