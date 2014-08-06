<%@ page import="ticbox.Survey" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="admin"/>
    <title></title>

    <link rel="stylesheet" type="text/css" href="${resource(dir: 'frameworks/jqplot', file: 'jquery.jqplot.min.css')}" />

    <style type="text/css">

    /*.surveyItemContainer {*/
    /*margin-bottom: 10px;*/
    /*clear: right;*/
    /*}*/

    /*.surveyItemContainer .seqNumberContainer {*/
    /*width: 40px;*/
    /*vertical-align: top;*/
    /*text-align: right;*/
    /*padding-right: 5px;*/
    /*}*/

    /*.surveyItemContainer .questionNumber {*/
    /*font-size: 24px;*/
    /*font-weight: bold;*/
    /*color: #97b11a;*/
    /*}*/

    /*.chart-container {*/
    /*margin-left: 50px;*/
    /*}*/

    /*#displaySurveyResultModal {*/
    /*top: 5%;*/
    /*}*/

    /*#displaySurveyResultModal .modal-body {*/
    /*max-height: 450px;*/
    /*}*/

    /*#displaySurveyResultModal .modal-footer {*/
    /*padding: 5px 15px 5px;*/
    /*}*/

    #menuNavPanelContent {
        width: 100%;
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

%{--<div id="menuNavPanelContent">--}%
    %{--<div class="module">--}%
    %{--<div class="line side-panel">--}%
    %{--<div class="line header">--}%
    %{--Panel 1--}%
    %{--</div>--}%
    %{--<div class="line">--}%

    %{--</div>--}%

    %{--<hr>--}%
    %{--</div>--}%

    %{--<div class="line side-panel">--}%
    %{--<div class="line header">--}%
    %{--Panel 2--}%

    %{--</div>--}%
    %{--<div class="line">--}%

    %{--</div>--}%

    %{--<hr>--}%
    %{--</div>--}%
    %{--</div>--}%

    %{--div>--}%
    %{--</div><div class="" style="width: 100%">--}%
    %{--<div class="line line-centered">--}%
        %{--<button style="border-radius: 8px; width: 100%" id="createSurveyModalBtn" href="#createSurveyModal" role="button" data-toggle="modal" class="btn btn-green btn-lg" type="button"><g:message code="label.button.create" default="Create"/> Survey</button>--}%
    %{--</--}%

%{--</div>--}%


<div class="module">

    <div id="surveyHeader" class="module-header">
        <div class="title">Your Survey List</div>
    </div>
    <div id="surveyList" class="module-content">
        <div class="row" style="margin-bottom:10px">
            <div class="col-sm-12">
                <a id="delSubmitedSurvey" href="#delete-submitted-survey-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> Delete</a>
            </div>
        </div>
        <div style="width: 100%">
            <table class="table table-striped table-bordered table-hover">
                <thead>
                <tr class="top-header">
                    <th colspan="5">SUBMITTED</th>
                </tr>
                <tr class="sub-header">
                    <th></th>
                    <th>Name</th>
                    <th>Total Charge</th>
                    <th>Modified</th>
                    <th>Point</th>

                </tr>
                </thead>
                <tbody>
                <g:if test="${submitted.isEmpty()}">
                    <tr>
                        <td colspan="5" style="font-style: italic; font-size: 12px; color: #9f7032;">No survey yet..</td>
                    </tr>
                </g:if>
                <g:each in="${submitted}" var="survey">
                <g:form name="finalizeForm" action="finalizeAndPublishSurvey" class="form-horizontal" role="form">
                    <input type="hidden" name="surveyId" value="${survey.surveyId}"/>
                    <tr>
                        <td><input type="checkbox" name="surveySubmitedIds"  value="${survey.id}" /></td>
                        <td><a class="displayQuestionLink" href="javascript:void(0)" surveyid="${survey.surveyId}">${survey.name}</a></td>
                        <td></td>
                        <td></td>
                        <td><g:textField name="surveyPoint" data-max="100" data-min="0" class="num form-control" style="text-align:right;min-width: 40%; width: auto;"/>
                        </td>
                        <td class="content-width">
                            <g:submitButton name="submit" value="${g.message(code:'label.button.finalize')}" class="btn btn-xs btn-primary displayResultLink"/>

                            %{--<a class="btn btn-xs btn-primary displayResultLink" href="${request.contextPath}/admin/finalizeAndPublishSurvey?surveyId=${survey.surveyId}&surveyPoint=$("input[name='${survey.surveyId}']").val()">--}%
                            %{--<g:message code="label.button.finalize" default="Finalize and Publish"/></a>--}%
                        </td>
                    </tr>
                </g:form>
                </g:each>
                </tbody>
            </table>
            <div class="row" style="margin-bottom:10px">
                <div class="col-sm-12">
                    <a id="delInprogressSurvey" href="#delete-inprogress-survey-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> Delete</a>
                    <a id="disableInprogressSurvey" href="#disable-inprogress-survey-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> Disable</a>
                    <a id="enableInprogressSurvey" href="#enable-inprogress-survey-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> Enable</a>
                </div>
            </div>
            <table class="table table-striped table-bordered table-hover">
                <thead>
                <tr class="top-header">
                    <th colspan="5">IN PROGRESS</th>
                </tr>
                <tr class="sub-header">
                    <th></th>
                    <th>Name</th>
                    <th>Running Time</th>
                    <th>Status</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <g:if test="${inProgress.isEmpty()}">
                    <tr>
                        <td colspan="5" style="font-style: italic; font-size: 12px; color: #9f7032;">No survey yet..</td>
                    </tr>
                </g:if>
                <g:each in="${inProgress}" var="survey">
                    <tr>
                        <td><input type="checkbox" name="surveyInprogressIds"  value="${survey.id}" /></td>
                        <td><a class="displayQuestionLink" href="javascript:void(0)" surveyid="${survey.surveyId}">${survey.name}</a></td>
                        <td></td>
                        <td></td>
                        <td class="content-width">
                            <a class="btn btn-xs btn-primary displayResultLink" surveyid="${survey.surveyId}" href="javascript:void(0)">Display Result</a>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>

            <table class="table table-striped table-bordered table-hover">
                <thead>
                <tr class="top-header">
                    <th colspan="5">COMPLETED</th>
                </tr>
                <tr class="sub-header">
                    <th>Name</th>
                    <th>Total Respondents</th>
                    <th>Stats</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <g:if test="${completes.isEmpty()}">
                    <tr>
                        <td colspan="5" style="font-style: italic; font-size: 12px; color: #9f7032;">No survey yet..</td>
                    </tr>
                </g:if>
                <g:each in="${completes}" var="survey">
                    <tr>
                        <td><a href="${request.contextPath}/survey/editSurvey?surveyId=${survey.surveyId}">${survey.name}</a></td>
                        <td></td>
                        <td></td>
                        <td></td>
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
                    Delete Surveys
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
                <button id="deleteSubmittedSurveys" class="btn btn-danger" data-loading-text="Processing..">Delete</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
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
                    Delete Surveys
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
                <button id="deleteInprogressSurveys" class="btn btn-danger" data-loading-text="Processing..">Delete</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
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
                    Disable Surveys
                </span>
            </div>
            <div class="modal-body">
                <g:form name="disableSurveysForm" controller="admin" action="disableSurveys" role="form">
                    <input type="hidden" id="disableSurveyIds" name="disableSurveyIds" value=""/>
                    <div class="well">
                        <p><b>Are you sure to disable these surveys?</b></p>
                        There is no rollback for deleted surveys. Please make sure you know what you are doing.
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="disableSurveys" class="btn btn-danger" data-loading-text="Processing..">Disable</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
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
                    Enable Surveys
                </span>
            </div>
            <div class="modal-body">
                <g:form name="enableSurveysForm" controller="admin" action="enableSurveys" role="form">
                    <input type="hidden" id="enableSurveyIds" name="enableSurveyIds" value=""/>
                    <div class="well">
                        <p><b>Are you sure to enable these surveys?</b></p>
                        There is no rollback for deleted surveys. Please make sure you know what you are doing.
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="enableSurveys" class="btn btn-danger" data-loading-text="Processing..">Enable</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
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
            %{--<label class="checkbox">--}%
            %{--<div class="col col-xs-1" style="text-align: right">--}%
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

%{--<div id="answerPreviewTemplate-singleChoice" class="answerTemplate row" type="${Survey.QUESTION_TYPE.CHOICE}">--}%
%{--<div class="col col-xs-11 col-xs-offset-1">--}%
%{--<select class="item-select" style="min-width: 200px">--}%
%{--<option></option>--}%
%{--</select>--}%
%{--</div>--}%
%{--</div>--}%

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

<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot', file: 'jquery.jqplot.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.pieRenderer.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.highlighter.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.cursor.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.dateAxisRenderer.min.js')}"></script>
<g:javascript src="jquery.validate.min.js"/>
<script type="text/javascript">


    jQuery(function(){

        $('#deleteSubmittedSurveys').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#deleteSurveysForm');
            $('input[name=surveySubmitedIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            $('#delSurveyIds', form).val(selected);
            form.submit();
        });

        $('#deleteInprogressSurveys').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#deleteSurveysForm');
            $('input[name=surveyInprogressIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            $('#delSurveyIds', form).val(selected);
            form.submit();
        });

        $('#disableSurveys').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#disableSurveysForm');
            $('input[name=surveyInprogressIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            $('#disableSurveyIds', form).val(selected);
            form.submit();
        });

        $('#enableSurveys').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#enableSurveysForm');
            $('input[name=surveyInprogressIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            $('#enableSurveyIds', form).val(selected);
            form.submit();
        });

        jQuery('.displayResultLink').click(function(){
            var that = jQuery(this);
            var surveyId = that.attr('surveyid');

            var txt = that.text();
            //that.text('Loading Data..');

            jQuery.getJSON('${request.contextPath}/survey/getSurveyResult', {surveyId: surveyId}, function(result){

                jQuery('#displaySurveyResultModal').modal('show').find('.questionItemsContainer').empty();

                setTimeout(function() {
                    loadResultGraph(result);

                    that.text(txt);
                }, 500);
            });
        });

        jQuery('#surveyorProfileContent').addClass('in');
        jQuery('#surveyInfoAccordion').hide();

        jQuery('.displayQuestionLink').click(function(){
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
                        jQuery('.item-label', choiceItemContainer).html(choiceItem);
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

        if (result) {

            jQuery.each(result, function(key, item){

                var questionItem = item.questionItem;
                var summary = item.summary;

                var answerDetails = questionItem.answerDetails;
                var container = constructQuestionItemCont(questionItem.questionStr, key);

                questionItemsContainer.append(container);

                var target = jQuery('.chart-container .col .chart:first', container);

                switch(answerDetails.type){

                    case '${Survey.QUESTION_TYPE.CHOICE}' :

                        var data = [];

                        jQuery.each(summary, function(label, count){
                            data.push([label, count]);
                        });

                        constructPieChart(target, data, 'Answer Type - Choice');

                        break;

                    case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                        var line1= [['23-May-08', 578.55], ['20-Jun-08', 566.5], ['25-Jul-08', 480.88], ['22-Aug-08', 509.84],
                            ['26-Sep-08', 454.13], ['24-Oct-08', 379.75], ['21-Nov-08', 303], ['26-Dec-08', 308.56],
                            ['23-Jan-09', 299.14], ['20-Feb-09', 346.51], ['20-Mar-09', 325.99], ['24-Apr-09', 386.15]];

                        constructLineChart(target, line1, 'Answer Type - Free Text');

                        break;

                    case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                        jQuery.each(summary, function(rowLabel, rowSummary){

                            var data = [];

                            jQuery.each(rowSummary, function(colLabel, count){
                                data.push([colLabel, count]);
                            });

                            var targetCopy = target.clone();

                            jQuery('.chart-container .col', container).append(targetCopy);

                            constructPieChart(targetCopy, data, 'Scale Rating (' + rowLabel + ')');
                        });

                        target.remove();

                        break;

                    case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                        var data = [];

                        jQuery.each(summary, function(label, count){
                            data.push([label, count]);
                        });

                        constructPieChart(target, data, 'Answer Type - Star Rating');

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