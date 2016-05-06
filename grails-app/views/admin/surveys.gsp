<%@ page import="ticbox.Survey" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="admin"/>
    <title></title>

    <link rel="stylesheet" type="text/css" href="${resource(dir: 'frameworks/jqplot', file: 'jquery.jqplot.min.css')}" />

    <style type="text/css">

    .dataTable {
        margin-bottom: 5px !important;
    }

    .dataTables_paginate {
        margin-bottom: 20px;
    }

    .module-content .table tr.top-header th {
        background-color: rgba(134, 137, 122, 1.0); /* #86897a */
        font-weight: bold;
        height: 25px;
        color: #ffffff;
    }

    .module-content .table tr.sub-header th {
        font-weight: bold;

        background-color: lightgrey;
        background-image: linear-gradient(-45deg, rgba(255, 255, 255, 0.2) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, 0.2) 50%, rgba(255, 255, 255, 0.2) 75%, transparent 75%, transparent);

        background-size: 20px 20px;
        height: 15px;
        line-height: 15px;

    }

    </style>

</head>
<body>

<div class="module">

    <div id="surveyHeader" class="module-header">
        <div class="title"><g:message code="ticbox.admin.survey.header"/></div>
    </div>
    <div id="surveyList" class="module-content">
        <div style="width: 100%" id="surveyList">
            <div class="row" style="margin-bottom:10px">
                <div class="col-sm-12">
                    <a id="delInprogressSurvey" href="#delete-inprogress-survey-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> <g:message code="default.button.delete.label"/></a>
                    <a id="disableInprogressSurvey" href="#disable-inprogress-survey-modal" role="button" class="btn btn-warning" data-toggle="modal"><i class="icon-remove icon-white"></i> <g:message code="default.button.disable.label"/></a>
                    <a id="enableInprogressSurvey" href="#enable-inprogress-survey-modal" role="button" class="btn btn-blue-trust" data-toggle="modal"><i class="icon-remove icon-white"></i> <g:message code="default.button.enable.label"/></a>
                </div>
            </div>
            <table id="inProgressTable" class="table table-striped table-bordered table-hover">
                <thead>
                <tr class="top-header">
                    <th colspan="9"><g:message code="app.inprogress.status"/></th>
                </tr>
                <tr class="sub-header">
                    <th></th>
                    <th><g:message code="app.name.title"/></th>
                    <th><g:message code="app.owner.label"/></th>
                    %{--<th><g:message code="app.type.label"/></th>--}%
                    <th><g:message code="app.point.label"/></th>
                    <th><g:message code="app.createddate.label"/></th>
                    <th><g:message code="app.enddate.label"/></th>
                    %{--<th><g:message code="app.price.label"/></th>--}%
                    <th><g:message code="app.status.label"/></th>
                    <th><g:message code="app.action.label"/></th>
                </tr>
                </thead>
                <tbody>
                %{--<g:if test="${inProgress.isEmpty()}">--}%
                    %{--<tr>--}%
                        %{--<td colspan="5" style="font-style: italic; font-size: 12px; color: #9f7032;">No survey yet..</td>--}%
                    %{--</tr>--}%
                %{--</g:if>--}%
                <g:each in="${inProgress}" var="survey">
                    <tr>
                        <td><input type="checkbox" name="surveyInprogressIds"  value="${survey.id}" /></td>
                        <td><a class="displayQuestionLink" href="javascript:void(0)" surveyid="${survey.surveyId}">${survey.name}</a></td>
                        <td>${survey.surveyor.userAccount.username}</td>
                        %{--<td>${survey.type}</td>--}%
                        <td>${survey.point}</td>
                        <td>${survey.createdDate}</td>
                        <td>${survey.completionDateTo}</td>
                        %{--<td>Rp. ${survey.surveyPrice}</td>--}%
                        <td>
                            <g:if test="${survey.enableStatus=='DISABLED'}">
                                <span style="color:red">${survey.enableStatus}</span>
                            </g:if>
                            <g:else>
                                ${survey.enableStatus}
                            </g:else>
                        </td>
                        <td class="content-width">
                            <a class="btn btn-xs btn-primary setPointLink" surveyid="${survey.surveyId}" href="javascript:void(0)">Set Point</a>
                            <a class="btn btn-xs btn-primary displayResultLink" surveyid="${survey.surveyId}" href="javascript:void(0)">Display</a>
	                        <a class="btn btn-xs btn-primary downloadResultLink" surveyid="${survey.surveyId}" href="javascript:void(0)">Download</a>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>

            <table id="completedTable"  class="table table-striped table-bordered table-hover">
                <thead>
                <tr class="top-header">
                    <th colspan="8"><g:message code="app.completed.status"/></th>
                </tr>
                <tr class="sub-header">
                    <th><g:message code="app.name.title"/></th>
                    <th><g:message code="app.owner.label"/></th>
                    %{--<th><g:message code="app.type.label"/></th>--}%
                    <th><g:message code="app.createddate.label"/></th>
                    <th><g:message code="app.runningtime.label"/></th>
                    <th><g:message code="app.respondents.label"/></th>
                    %{--<th><g:message code="app.price.label"/></th>--}%
                    <th><g:message code="app.action.label"/></th>
                </tr>
                </thead>
                <tbody>
                %{--<g:if test="${completes.isEmpty()}">--}%
                    %{--<tr>--}%
                        %{--<td colspan="5" style="font-style: italic; font-size: 12px; color: #9f7032;">No survey yet..</td>--}%
                    %{--</tr>--}%
                %{--</g:if>--}%
                <g:each in="${completes}" var="survey">
                    <tr>
                        <%--td><a class="displayQuestionLink" href="javascript:void(0)" surveyid="${survey.surveyId}">${survey.name}</a></td--%>
                        <!--td>${survey.name}</td-->
                        <td><a class="displayQuestionLink" href="javascript:void(0)" surveyid="${survey.surveyId}">${survey.name}</a></td>
                        <td>${survey.surveyor.userAccount.username}</td>
                        %{--<td>${survey.type}</td>--}%
                        <td>${survey.createdDate}</td>
                        <td>${survey.completionDateFrom} - ${survey.completionDateTo}</td>
                        <td>${survey.ttlRespondent}</td>
                        %{--<td>Rp. ${survey.surveyPrice}</td>--}%
                        <td class="content-width">
                            <a class="btn btn-xs btn-primary displayResultLink" surveyid="${survey.surveyId}" href="javascript:void(0)">Display</a>
	                        <a class="btn btn-xs btn-primary downloadResultLink" surveyid="${survey.surveyId}" href="javascript:void(0)">Download</a>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>

        </div>
    </div>
</div>

<div id="createSurveyModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="createSurveyModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="createSurveyModalLabel" class="modal-title">
                    Create Survey
                </span>
            </div>
            <div class="modal-body" style="overflow: auto">
                <label for="surveyName">Please name your survey</label>
                <input type="text" class="form-control" id="surveyName" name="surveyName" param-of="createSurveyBtn">
            </div>
            <div class="modal-footer">
                <button href="${request.contextPath}/survey/createSurvey" id="createSurveyBtn" class="btn btn-green submit-redirect"><g:message code="label.button.create" default="Create"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.close" default="Close"/></button>
            </div>
        </div>
    </div>
</div>

<div id="displaySurveyResultModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="displaySurveyResultModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="displaySurveyResultModalLabel" class="modal-title">
                    Survey Result
                </span>
            </div>
            <div class="modal-body" style="overflow: auto">
                <div class="questionItemsContainer">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.close" default="Close"/></button>
            </div>
        </div>
    </div>
</div>

<div id="surveyPreviewModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="surveyPreviewModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="surveyPreviewModalLabel" class="modal-title" >Survey Preview</span>
            </div>
            <div class="modal-body" style="overflow: auto; padding: 20px 50px 20px 20px">
                <div class="questionItemsContainer">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.close" default="Close"/></button>
            </div>
        </div>
    </div>
</div>

<div id="delete-submitted-survey-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="deleteSurveyLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="deleteSubmittedSurveyLabel" class="modal-title">
                    <g:message code="default.deletesurveys.label"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="deleteSurveysForm" controller="admin" action="deleteSurveys" role="form">
                    <input type="hidden" id="delSurveyIds" name="delSurveyIds" value=""/>
                    <div class="well">
                        <p><b>Are you sure to delete these surveys?</b></p>
                        There is no rollback for deleted surveys. Please make sure you know what you are doing.
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="deleteSubmittedSurveys" class="btn btn-danger" data-loading-text="Processing.."><g:message code="default.button.delete.label"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button>
            </div>
        </div>
    </div>
</div>

<div id="delete-inprogress-survey-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="deleteSurveyLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="deleteInprogressSurveyLabel" class="modal-title">
                    <g:message code="default.deletesurveys.label"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="deleteSurveysForm" controller="admin" action="deleteSurveys" role="form">
                    <input type="hidden" id="delSurveyIds" name="delSurveyIds" value=""/>
                    <div class="well">
                        <p><b>${g.message(code: "app.admin.survey.delete.confirmation")}</b></p>
                        ${g.message(code: "app.admin.survey.delete.warning")}
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="deleteInprogressSurveys" class="btn btn-danger" data-loading-text="Processing.."><g:message code="default.button.delete.label"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button>
            </div>
        </div>
    </div>
</div>

<div id="disable-inprogress-survey-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="disableSurveyLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="disableSurveyLabel" class="modal-title">
                    <g:message code="default.disablesurveys.label"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="disableSurveysForm" controller="admin" action="disableSurveys" role="form">
                    <input type="hidden" id="disableSurveyIds" name="disableSurveyIds" value=""/>
                    <div class="well">
                        <p><b>${g.message(code: "app.admin.survey.disable.confirmation")}</b></p>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="disableSurveys" class="btn btn-danger" data-loading-text="Processing.."><g:message code="default.button.disable.label"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button>
            </div>
        </div>
    </div>
</div>

<div id="enable-inprogress-survey-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="enableSurveyLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="enableSurveyLabel" class="modal-title">
                    <g:message code="default.enablesurveys.label"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="enableSurveysForm" controller="admin" action="enableSurveys" role="form">
                    <input type="hidden" id="enableSurveyIds" name="enableSurveyIds" value=""/>
                    <div class="well">
                        <p><b>${g.message(code: "app.admin.survey.enable.confirmation")}</b></p>
                        <g:checkBox name="enableBlast" id="enableBlast"/>
                        ${g.message(code: "app.admin.survey.enable.blast")}
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="enableSurveys" class="btn btn-danger" data-loading-text="Processing.."><g:message code="default.button.enable.label"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button>
            </div>
        </div>
    </div>
</div>

<!-- kucing modal -->
 <div id="set-point-survey-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="setPointSurveyLabel" aria-hidden="true"> 
    <div class="modal-dialog"> 
        <div class="modal-content"> 
            <div class="modal-header"> 
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button> 
                <span id="setPointSurveyLabel" class="modal-title"> 
                    <g:message code="default.setpointsurvey.label"/> 
                </span> 
            </div> 
            <div class="modal-body"> 
                <g:form name="setPointSurveyForm" controller="admin" action="savePointSurvey" role="form"> 
                    <input type="hidden" id="savePointSurveyId" name="savePointSurveyId" /> 
                    <div class="well"> 
                        <label class="" ><g:message code="survey.addgoldpoint.label"/></label> 
                        <select id="surveyPoint" name="surveyPoint" class="form-control"> 
                            <option value="0">0</option> 
                            <option value="5">5</option> 
                            <option value="10">10</option> 
                            <option value="15">15</option> 
                            <option value="20">20</option> 
                        </select> 
                    </div> 
                </g:form> 
            </div> 
            <div class="modal-footer"> 
                <button id="setPointSurvey" class="btn btn-blue-trust" data-loading-text="Processing.."><g:message code="label.button.setpoint"/></button> 
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button> 
            </div> 
        </div> 
    </div>
 </div>

<div class="templates" style="display: none;">

<div id="questionPreviewTemplate" class="surveyItemContainer">
    <div class="row">
        <div class="seqNumberContainer questionNumber col-xs-1"> </div>
        <div class="questionTextContainer col-xs-11">
            <span class="question-text"></span>
        </div>
    </div>
</div>

<div id="answerPreviewTemplate-singleText" class="answerTemplate row" type="${Survey.QUESTION_TYPE.FREE_TEXT}">
    <div class="col col-xs-11 col-xs-offset-1">
        <textarea class="form-control" rows="3" placeholder="" style="width: 100% !important;"></textarea>
    </div>
</div>

<div id="answerPreviewTemplate-multipleChoice" class="answerTemplate row" type="${Survey.QUESTION_TYPE.CHOICE}">
    <div class="choice-items col-xs-11 col-xs-offset-1">
        <div class="choice-item row">
            <div class="col col-xs-12">
                <input class="item-check" type="checkbox">
                %{--</div>--}%
                %{--<div class="col col-xs-11" style="padding-left: 0">--}%
                <span class="item-label" style="font-weight: normal; margin-bottom: 0"></span>
            </div>
            %{--</label>--}%
        </div>
    </div>
</div>

<div id="answerPreviewTemplate-singleChoice" class="answerTemplate row" type="${Survey.QUESTION_TYPE.CHOICE}">
    <div class="choice-items col-xs-11 col-xs-offset-1">
        <div class="choice-item row">
            %{--<div class="col col-xs-1" style="text-align: right">--}%
            <div class="col col-xs-12">
                <input class="item-check" type="radio">
                %{--</div>--}%
                %{--<div class="col col-xs-11" style="padding-left: 0">--}%
                <span class="item-label" style="font-weight: normal; margin-bottom: 0"></span>
            </div>
        </div>
    </div>
</div>

<div id="answerPreviewTemplate-scale" class="answerTemplate row" type="${Survey.QUESTION_TYPE.SCALE_RATING}">
    <div class="col col-xs-11 col-xs-offset-1" style="overflow-x: auto;width: auto">
        <table class="table scale-table table-bordered table-responsive">
            <thead>
            <tr class="scale-head">
                <th style="text-align: center;"></th>
                %{--<th class="rating-label" style="text-align: center"></th>--}%
            </tr>
            </thead>
            <tbody>
            <tr class="scale-row">
                <td class="row-label"> </td>
                <td class="rating-weight" style="text-align: center">
                    <input type="radio" name="rd-1">
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>

<div id="answerPreviewTemplate-starRating" class="answerTemplate row" type="${Survey.QUESTION_TYPE.STAR_RATING}">
    <div class="line stars col-xs-11 col-xs-offset-1">

    </div>
</div>
</div>

<div class="templates">

    <div id="questionItemTemplate" class="surveyItemContainer">
        <div class="row">
            <div class="seqNumberContainer questionNumber col-xs-1"> </div>
            <div class="questionTextContainer col-xs-11" style="max-width: 90%">
                <span class="question-text"></span>
            </div>
        </div>
        <div class="chart-container row" style="padding-top: 10px;">
            <div class="col col-xs-11 col-xs-offset-1">
                <div class="chart" style="height:300px;width:500px;"></div>
            </div>
        </div>

    </div>
</div>

<script type="text/javascript" src="${resource(dir: 'js', file: 'chart-helper.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot', file: 'jquery.jqplot.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.pieRenderer.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.highlighter.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.cursor.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.dateAxisRenderer.min.js')}"></script>

<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.barRenderer.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.categoryAxisRenderer.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.pointLabels.min.js')}"></script>


<g:javascript src="jquery.validate.min.js"/>
<script type="text/javascript">


    jQuery(function(){

        $('#inProgressTable').DataTable( {
            "ordering": false,
            "info":     false,
            "searching": false,
            "oLanguage": {
                "sEmptyTable": "No survey yet..",
                "sLengthMenu": 'Display <select>'+
                        '<option value="5">5</option>'+
                        '<option value="10">10</option>'+
                        '<option value="20">20</option>'+
                        '<option value="-1">All</option>'+
                        '</select> records'
            }
        } );

        $('#completedTable').DataTable( {
            "ordering": false,
            "info":     false,
            "searching": false,
            "oLanguage": {
                "sEmptyTable":     "No survey yet..",
                "sLengthMenu": 'Display <select>'+
                        '<option value="5">5</option>'+
                        '<option value="10">10</option>'+
                        '<option value="20">20</option>'+
                        '<option value="-1">All</option>'+
                        '</select> records'
            }
        } );

        // Don't use regular .onclick event on dynamic pages such as paginated pages
        // http://learn.jquery.com/events/event-delegation/
        $(document).on('click',"#deleteInprogressSurveys",function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#deleteSurveysForm');
            $('input[name=surveyInprogressIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            $('#delSurveyIds', form).val(selected);
            form.submit();
        });

        $(document).on('click',"#disableSurveys",function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#disableSurveysForm');
            $('input[name=surveyInprogressIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            $('#disableSurveyIds', form).val(selected);
            form.submit();
        });

        $(document).on('click',"#enableSurveys",function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#enableSurveysForm');
            $('input[name=surveyInprogressIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            $('#enableSurveyIds', form).val(selected);
            form.submit();
        });

        $(document).on('click',"#setPointSurvey",function() {
            $(this).button('loading');
            var form= $('#setPointSurveyForm');

            form.submit();
        });

        $(document).on('click',".setPointLink",function() {
            var that = jQuery(this);
            var surveyId = that.attr('surveyid');

            $('#set-point-survey-modal').modal('show');
            $('#savePointSurveyId').val(surveyId);
        });

        $(document).on('click',".displayResultLink",function() {
            var that = jQuery(this);
            var surveyId = that.attr('surveyid');

            var txt = that.text();
            //that.text('Loading Data..');

            jQuery.getJSON('${request.contextPath}/survey/getSurveyResult', {surveyId: surveyId}, function(result){
                if(!result.error){
                    jQuery('#displaySurveyResultModal').modal('show').find('.questionItemsContainer').empty();

                    setTimeout(function() {
                        loadResultGraph(result);

                        that.text(txt);
                    }, 500);
                    jQuery('.displayResultLink').text('Display Result');
                } else {
                    alert(result.error);
                    that.text(txt);
                }

            });
        });
        
        $(document).on('click',".downloadResultLink",function(e) {
	        var that = jQuery(this);
            var surveyId = that.attr('surveyid');
           	e.preventDefault();  //stop the browser from following
			var url =  '${request.contextPath}/survey/downloadSurveyResult?surveyId='+surveyId;
			window.location.href =url;
        });

        jQuery('#surveyorProfileContent').addClass('in');
        jQuery('#surveyInfoAccordion').hide();

        $(document).on('click',".displayQuestionLink",function() {
            var that = jQuery(this);
            var surveyId = that.attr('surveyid');

           // var txt = that.text();
            //that.text('Loading Data..');
            jQuery('#surveyPreviewModal .modal-body').empty();
            jQuery.getJSON('${request.contextPath}/survey/getQuestionItems', {surveyId: surveyId}, function(result){

                jQuery('#surveyPreviewModal').modal('show').find('.questionItemsContainer').empty();

                setTimeout(function() {
                    loadQuestionGraph(result);

            //        that.text(txt);
                }, 500);
            });
        });

    });



    function constructQuestionItemCont(questionStr, seq){

        var cont = jQuery('#questionItemTemplate').clone().attr('id', 'qi_'+seq);

        jQuery('.questionNumber', cont).html(seq + '.');
//        jQuery('.questionTextContainer > span.question-text', cont).html(questionStr);
        jQuery('.questionTextContainer > span.question-text', cont).html("<span style='font-size:24px;color:grey;'>"+questionStr.charAt(0)+"</span>" + questionStr.substring(1));

        jQuery('.chart-container .col .chart', cont).attr('id', 'chart_'+seq);

        return cont;
    }

    function loadQuestionGraph(questionItems){

        console.log('~ BEGIN constructPreview');
        jQuery.each(questionItems, function(idx, item){

            var questionStr = item.questionStr;
            var answerDetails = item.answerDetails;

            var questionTemplate = jQuery('#questionPreviewTemplate').clone().removeAttr('id');

            jQuery('.seqNumberContainer', questionTemplate).html(idx+1+'.');

            jQuery('.question-text', questionTemplate).html("<span style='font-size:24px;color:grey;'>"+questionStr.charAt(0)+"</span>" + questionStr.substring(1));

            var answerTemplate = null;

            switch(answerDetails.type){

                case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :

                    var choiceItems = answerDetails.choiceItems;
                    var choiceType = answerDetails.choiceType;

                    answerTemplate = jQuery('#answerPreviewTemplate-singleChoice').clone().removeAttr('id');

//                                jQuery.each(choiceItems, function(idx, choiceItem){
                    jQuery.each(choiceItems, function(j, choiceItem){
//                                    jQuery('.item-select', answerTemplate).append(jQuery('<option></option>').append(choiceItem).val(choiceItem));
                        var choiceItemContainer = jQuery('.choice-item:first', answerTemplate).clone();
                        jQuery('input.item-check', choiceItemContainer).attr('name', idx);
                        jQuery('input.item-check', choiceItemContainer).val(choiceItem);
                        jQuery('.item-label', choiceItemContainer).html(choiceItem.label);
//                                    answerTemplate.append(choiceItemContainer);
                        jQuery('.choice-items', answerTemplate).append(choiceItemContainer);  //<-- geuis edit
                    });
                    jQuery('.choice-item:first', answerTemplate).remove();

                    break;

                case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :

                    var choiceItems = answerDetails.choiceItems;
                    var choiceType = answerDetails.choiceType;

                    answerTemplate = jQuery('#answerPreviewTemplate-multipleChoice').clone().removeAttr('id');

//                                jQuery.each(choiceItems, function(idx, choiceItem){
                    jQuery.each(choiceItems, function(j, choiceItem){
                        var choiceItemContainer = jQuery('.choice-item:first', answerTemplate).clone();
                        jQuery('input.item-check', choiceItemContainer).val(choiceItem);
                        jQuery('.item-label', choiceItemContainer).html(choiceItem);
//                                    answerTemplate.append(choiceItemContainer);
                        jQuery('.choice-items', answerTemplate).append(choiceItemContainer);  //<-- geuis edit
                    });
                    jQuery('.choice-item:first', answerTemplate).remove();

                    break;

                case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                    answerTemplate = jQuery('#answerPreviewTemplate-singleText').clone().removeAttr('id');
                    jQuery('textarea', answerTemplate).attr('placeholder', answerDetails.questionPlaceholder);

                    break;

                case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                    answerTemplate = jQuery('#answerPreviewTemplate-scale').clone().removeAttr('id');

                    var ratingLabels = answerDetails.ratingLabels;
                    var rowLabels = answerDetails.rowLabels;

                    jQuery.each(ratingLabels, function(idx, ratingLabel){
                        jQuery('.scale-head', answerTemplate).append(jQuery('<th class="rating-label" style="text-align: center"></th>').html(ratingLabel));
                    });

                    jQuery.each(rowLabels, function(idx, rowLabel){
                        var scaleRow = jQuery('table.scale-table > tbody > tr.scale-row:first', answerTemplate).clone();
                        jQuery('.row-label', scaleRow).html(rowLabel);

                        jQuery.each(ratingLabels, function(idx, ratingLabel){
                            var ratingWeightCont = jQuery('td.rating-weight:first', scaleRow).clone();
                            jQuery('input', ratingWeightCont).attr('name', rowLabel);
                            scaleRow.append(ratingWeightCont);
                        });
                        jQuery('td.rating-weight:first', scaleRow).remove();

                        jQuery('table.scale-table > tbody', answerTemplate).append(scaleRow);
                    });
                    jQuery('table.scale-table > tbody > tr.scale-row:first', answerTemplate).remove();

                    break;

                case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                    answerTemplate = jQuery('#answerPreviewTemplate-starRating').clone().removeAttr('id');
                    var stars = jQuery('.stars', answerTemplate).empty();
                    for(var i = 0; i < parseInt(answerDetails.nofStars); i++){
                        jQuery('.stars', answerTemplate).append(jQuery('<div class="col star clickable" seq="'+i+'"></div>').click(function(){
                            var seq = parseInt(jQuery(this).attr('seq'));
                            jQuery('.star', stars).each(function(idx){
                                if(idx <= seq){
                                    jQuery(this).removeClass('basic');
                                    jQuery(this).addClass('active');
                                }else{
                                    jQuery(this).removeClass('active');
                                    jQuery(this).addClass('basic');
                                }
                            });

                        }));
                    }

                    break;

            }

            if (answerTemplate) {
                questionTemplate.append(answerTemplate);
            }

            jQuery('#surveyPreviewModal').find('.modal-body').append(questionTemplate);

        });

    }

    function loadResultGraph(result){

        var questionItemsContainer = jQuery('#displaySurveyResultModal').find('.questionItemsContainer');
        var renderer = new SurveyChartRenderer();

        if (result) {

            jQuery.each(result, function(key, item){

                var questionItem = item.questionItem;
                var summary = item.summary;

                var answerDetails = questionItem.answerDetails;
                var container = constructQuestionItemCont(questionItem.questionStr, key);

                questionItemsContainer.append(container);

                var target = jQuery('.chart-container .col .chart:first', container);

                switch(answerDetails.type){

                    case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :
                        var labels = [];
                        var counts = [];

                        if (summary){
                            jQuery.each(answerDetails.choiceItems, function (i, choiceItem) {
                                var label = choiceItem.label;
                                labels.push(label);
                                //labels.push(label.substring(0, 40));
                                counts.push(label in summary ? summary[label] : 0);
                            });

                            renderer.forChoice(labels, counts, target, 'Answer Type - Single Choice');
                        }
                        break;
                    case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :

//                        var data = [];
//
//                        if(summary){
//                            jQuery.each(summary, function (label, count) {
//                                data.push([label, count]);
//                            });
//
//                            constructPieChart(target, data, 'Answer Type - Choice');
//                        }
//                        break;
                        var labels = [];
                        var counts = [];

                        if (summary){
                            jQuery.each(answerDetails.choiceItems, function (i, choiceItem) {
                                var label = choiceItem.label;
                                if (('' + label) === 'undefined') { // back compat
                                    label = choiceItem;
                                }
                                labels.push(label);
                                counts.push(label in summary ? summary[label] : 0);
                            });

                            renderer.forChoice(labels, counts, target, 'Answer Type - Multiple Choice');
                        }
                        break;

                    case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

//                        var line1= [['23-May-08', 578.55], ['20-Jun-08', 566.5], ['25-Jul-08', 480.88], ['22-Aug-08', 509.84],
//                            ['26-Sep-08', 454.13], ['24-Oct-08', 379.75], ['21-Nov-08', 303], ['26-Dec-08', 308.56],
//                            ['23-Jan-09', 299.14], ['20-Feb-09', 346.51], ['20-Mar-09', 325.99], ['24-Apr-09', 386.15]];
//                        var tab = jQuery("<table></table>");
//                        jQuery.each(summary, function (index, val) {
//                            var row = jQuery('<tr><td>' + (index+1)+". " +  val + '</td></tr>');
//                            tab.append(row);
//                        });
//                        target.append(tab);
////                        constructLineChart(target, line1, 'Answer Type - Free Text');
//
//                        break;
                        if (summary) {
                            var MAX_NUM_OF_ANSWERS = 10;
                            // var answers = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ultricies commodo enim, eu euismod tortor porta ac. Sed in leo vulputate, aliquam eros tincidunt, condimentum ante. Nullam sed justo sit amet dolor feugiat commodo sed sed orci. Nullam tincidunt quis nunc eu lobortis. Pellentesque dolor diam, hendrerit quis imperdiet vel, aliquam in nibh. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam nec suscipit massa. Phasellus lorem eros, tincidunt ac interdum et, efficitur sed neque. Aenean bibendum mi libero, vitae porta nunc placerat pretium. Integer fermentum, purus quis molestie elementum, orci est dictum diam, nec tristique odio tellus a turpis. Sed non nibh vestibulum, varius sem sed, tristique nisi. Aenean velit ligula, eleifend eget tincidunt ac, sagittis et tellus. Integer ac purus in diam cursus placerat ac a tellus. Sed rutrum est et aliquet tincidunt. In id sapien condimentum, euismod elit vel, congue lectus. Nullam lacus augue, viverra quis ex in, finibus malesuada dolor'.split(".");
                            var answers = summary;

                            var tab = jQuery('<table class="table table-bordered table-striped"></table>');
                            var tbody = jQuery('<tbody sytle="height: 100px; overflow-y: auto; overflow-x: hidden;"></tbody>');
                            jQuery.each(answers, function (index, val) {
                                var row = jQuery('<tr><td>' + (index+1)+". " +  val + '</td></tr>');
                                tbody.append(row);
                            });
                            tab.append(tbody);
                            target.append(tab);

                            tab.paging({limit: MAX_NUM_OF_ANSWERS});
                        }
                        break;
                    case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

//                        if(summary) {
//                            var ticks =[];
//                            var series =[];
//                            var dataAll=[];
//                            var len= summary.length;
//                            var last;
//
//                            jQuery.each(summary, function (rowLabel, rowSummary) {
//
//                                var data = [];
//                                last=rowSummary;
//                                ticks.push(rowLabel);
//                                jQuery.first
//                                jQuery.each(rowSummary, function (colLabel, count) {
//                                    data.push(count);
//                                });
//                                dataAll.push(data);
//
//                            });
//                            jQuery.each(last, function (colLabel, count) {
//                                series.push({label:colLabel});
//                            });
//
//                            var targetCopy = target.clone();
//
//                            jQuery('.chart-container .col', container).append(targetCopy);
//
//
//                            constructMultipleChart(targetCopy, dataAll, 'Scale Rating',ticks,series);
//
//                            target.remove();
//                        }
//                        break;
                        if (summary) {
                            var itemValuesRows = [];

                            jQuery.each(answerDetails.rowLabels, function (i, rowLabel) {
                                var values = [];
                                jQuery.each(answerDetails.ratingLabels, function (j, colLabel) {
                                    values[j] = summary[rowLabel][colLabel] ? summary[rowLabel][colLabel] : 0;
                                });
                                itemValuesRows.push({'label': rowLabel, 'values': values});
                            });

                            renderer.forScale(answerDetails.ratingLabels, itemValuesRows, target, 'Answer Type - Scale');

                        }
                        break;
                    case '${Survey.QUESTION_TYPE.STAR_RATING}' :

//                        var data = [];
//
//                        jQuery.each(summary, function(label, count){
//                            data.push([label, count]);
//                        });
//
//                        constructPieChart(target, data, 'Answer Type - Star Rating');
//
//                        break;
                        var amounts = [];
                        if (summary) {
                            var i = 0;
                            for (i = 0; i < answerDetails.nofStars; i++) {
                                amounts[i] = 0;
                            }

                            jQuery.each(summary, function (star, count) {
                                amounts[star - 1] = count;
                            });

                            renderer.forStar(amounts, target, 'Answer Type - Star Rating');
                        }
                        break;

                }

            });

        }

    }

    function constructPieChart(target, data, title){

        return jQuery.jqplot (target, [data],
                {
                    seriesDefaults: {
                        // Make this a pie chart.
                        renderer: jQuery.jqplot.PieRenderer,
                        rendererOptions: {
                            // Put data labels on the pie slices.
                            // By default, labels show the percentage of the slice.
                            showDataLabels: true
                        }
                    },
                    legend: { show:true, location: 'e' },
                    title: {
                        text: title?title:'',
                        show: title != null
                    }
                }
        );

    }

    function constructMultipleChart(target, data, title,ticks,series){

        return jQuery.jqplot (target, data,
                {
                    stackSeries: true,
//                    captureRightClick: true,
                    seriesDefaults:{
                        renderer:$.jqplot.BarRenderer,
                        rendererOptions: {
                            // Put a 30 pixel margin between bars.
//                            barMargin: 30,
                            // Highlight bars when mouse button pressed.
                            // Disables default highlighting on mouse over.
//                            highlightMouseDown: true
                            barDirection: 'horizontal'
                        },
                        pointLabels: {show: true}
                    },series:series,

                    axes: {
                        yaxis: {
                            renderer: $.jqplot.CategoryAxisRenderer,
                            ticks:ticks
                        }
                    },
                    legend: { show:true, location: 'e' },
                    title: {
                        text: title?title:'',
                        show: title != null
                    }

                }
        );

    }
    function constructLineChart(target, data, title){

        return jQuery.jqplot(target, [data], {
            title:'Data Point Highlighting',
            axes:{
                xaxis:{
                    renderer:jQuery.jqplot.DateAxisRenderer,
                    tickOptions:{
                        formatString:'%b&nbsp;%#d'
                    }
                },
                yaxis:{
                    tickOptions:{
                        formatString:'$%.2f'
                    }
                }
            },
            highlighter: {
                show: true,
                sizeAdjust: 7.5
            },
            cursor: {
                show: false
            },
            title: {
                text: title?title:'',
                show: title != null
            }
        });
    }



</script>

</body>
</html>