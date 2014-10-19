<%@ page import="ticbox.Survey" contentType="text/html;charset=UTF-8" %>
<html>
<head>
<meta name="layout" content="respondent"/>
<title></title>

<style type="text/css">

    /*.surveyItemsContainer input, .surveyItemsContainer textarea, .surveyItemsContainer select {*/
        /*margin: 0;*/
    /*}*/

    /*.surveyItemsContainer input[type=text], .surveyItemsContainer textarea {*/
        /*width: 500px;*/
    /*}*/

    /*.surveyItemContainer {*/
        /*margin-bottom: 10px;*/
        /*clear: right;*/
    /*}*/

    /*.surveyItemContainer .seqNumberContainer {*/
        /*width: 40px;*/
        /*vertical-align: top;*/
        /*text-align: right;*/
        /*padding-right: 5px;*/
        /*line-height: 30px;*/
    /*}*/

    /*.questionTextContainer {*/
        /*line-height: 30px;*/
        /*vertical-align: bottom;*/
    /*}*/

    /*.questionNumber {*/
        /*font-size: 24px;*/
        /*font-weight: bold;*/
        /*color: #97b11a;*/
    /*}*/

    /*.surveyItemContainer table {*/
        /*margin-bottom: 0;*/
    /*}*/

    /*.surveyItemContainer .table th, .surveyItemContainer .table td {*/
        /*padding: 5px 1px;*/
    /*}*/

    /*.answerTemplate {*/
        /*margin: 0 0 0 45px;*/
    /*}*/

    /*.star {*/
        /*background:transparent url('../images/ticbox/question_BasicState.png');*/
        /*background-position: 52px -10px;*/
        /*width: 52px; height: 52px;*/
    /*}*/

    /*.stars:hover .star, .star.active{*/
        /*background:transparent url('../images/ticbox/question_ActiveState.png');*/
        /*background-position: 52px -10px;*/
    /*}*/

    /*.star:hover ~ .star, .star.basic{*/
        /*background:transparent url('../images/ticbox/question_BasicState.png');*/
        /*background-position: 52px -10px !important;*/
    /*}*/

</style>

<script type="text/javascript">

    var ttlQuestions = 0;
    var questionSeq = 1;

    jQuery(function () {

        jQuery('.enableTooltip').tooltip({
            selector: "button[data-toggle=tooltip]"
        });

        jQuery('#saveResponse').click(function () {

            var questionItems = buildSurveyResponseMap();
            saveResponse(questionItems, this);

        });
        jQuery('#nextQuestion').click(function () {
            var lastQuestion= jQuery('#question'+questionSeq).attr('hidden',true)
            var nextSeq = jQuery('input.item-check:checked',lastQuestion).attr('nextQuestion');
            if(nextSeq!=null||nextSeq==undefined)
                questionSeq++;
            else
                questionSeq=nextSeq;
            jQuery('#question'+questionSeq).attr('hidden',false)
            if(questionSeq>=ttlQuestions)
                jQuery('#nextQuestion').hide()

        });


        jQuery('#surveyName').text('${survey.name}');
        jQuery('#surveyTitle').text('${survey.title}');

        jQuery.getJSON('${request.contextPath}/respondent/getSurvey', {surveyId: '${survey.surveyId}'}, function (questionItems) {

            loadSurvey(questionItems);
            if(questionItems.length<2)
                jQuery('#nextQuestion').hide()
        });

    });

    function constructQuestionItem(type, subtype) {
        var answerComp = null;

        var changeTypeIconClass = '';

        switch (type) {

            case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :
            case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :
                if (type == '${Survey.QUESTION_TYPE.CHOICE_SINGLE}') {
                    answerComp = jQuery('#answerTemplate-choice-single').clone().removeAttr('id');
                    jQuery('.item-check', answerComp).attr('type', 'radio');
                } else if (type == '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}') {
                    answerComp = jQuery('#answerTemplate-choice-multiple').clone().removeAttr('id');
                    jQuery('.item-check', answerComp).attr('type', 'checkbox');
                }

                break;

            case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                answerComp = jQuery('#answerTemplate-singleText').clone().removeAttr('id');
                changeTypeIconClass = 'free-text-icon';

                break;

            case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                answerComp = jQuery('#answerTemplate-scale').clone().removeAttr('id');
                changeTypeIconClass = 'scale-rating-icon';

                break;

            case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                answerComp = jQuery('#answerTemplate-starRating').clone().removeAttr('id');
                changeTypeIconClass = 'star-rating-icon';

                break;

        }

        var questionComp = jQuery('#questionTemplate').clone().removeAttr('id').append(answerComp).appendTo('.surveyItemsContainer');

        jQuery('.change-question-type-btn', questionComp).addClass(changeTypeIconClass);

        jQuery('.surveyItemsContainer > .surveyItemContainer').each(function (idx) {
            jQuery('.questionNumber', jQuery(this)).html(idx + 1 + '.');
        });

        jQuery('.surveyItemActions .remove', questionComp).click(function () {
            jQuery(this).parents('.surveyItemContainer').remove();
            jQuery('.surveyItemsContainer > .surveyItemContainer').each(function (idx) {
                jQuery('.questionNumber', jQuery(this)).html(idx + 1 + '.');
            });
        });

        return questionComp;
    }

    function buildSurveyResponseMap() {
        var responseItem = [];
        var seq = 0;

        jQuery('.surveyItemsContainer > .surveyItemContainer').each(function () {

            var container = jQuery(this);
            var type = jQuery('.answerTemplate', container).attr('type');

            var questionStr = jQuery('.questionTextContainer > div', container).text();
            var answerDetails = {};
            answerDetails['type'] = type;

            switch (type) {

                case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :
                case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :
                    answerDetails['value'] = [];
                    jQuery('.item-check:checked', container).each(function () {
                        answerDetails['value'].push(jQuery(this).val());
                    });

                    break;

                case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                    answerDetails['value'] = jQuery('textarea', container).val();
                    break;

                case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                    answerDetails['value'] = {};
                    jQuery('.scale-row', container).each(function () {
                        var label = jQuery(this).find('.row-label').text();
                        var value = jQuery(this).find('input:checked').val();
                        answerDetails['value'][label] = (value) ? value : '';
                    });
                    break;

                case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                    answerDetails['value'] = jQuery('.stars .star.active', container).length;

                    break;

            }

            responseItem.push({
                seq : ++seq,
                answerDetails: answerDetails
            });

        });

        return responseItem
    }

    function saveResponse(questionItems, btn) {
        jQuery(btn).attr('disabled', 'disabled');
        jQuery.post('${request.contextPath}/respondent/saveResponse', {surveyResponse: JSON.stringify(questionItems), surveyId: '${survey.surveyId}', respondentId: ${respondent.id}}, function (data) {

            if ('SUCCESS' == data) {
                alert('Submission success..');
                window.location.replace('${request.contextPath}/respondent/');
            } else {
                alert('Submission failure');
                jQuery(btn).removeAttr('disabled');
            }

        });
    }

    function loadSurvey(questionItems) {

        if (questionItems) {

            jQuery.each(questionItems, function (i, item) {

                var answerDetails = item.answerDetails;
                var container = null;

                switch (answerDetails.type) {

                    case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :
                    case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :

                        var choiceItems = answerDetails.choiceItems;
                        var choiceType = answerDetails.choiceType;

                        container = constructQuestionItem(answerDetails.type, choiceType);

                        jQuery.each(choiceItems, function (j, choiceItem) {
                            var choiceItemCont = jQuery('.choice-items > .choice-item:first', container).clone();
                            choiceItemCont.find('.item-check').attr('name', i);
                            choiceItemCont.find('.item-check').val(choiceItem.label);
                            choiceItemCont.find('.item-check').attr('nextQuestion',choiceItem.nextQuestion);
                            jQuery('.choice-items', container).append(choiceItemCont);
                            if(answerDetails.type=='${Survey.QUESTION_TYPE.CHOICE_SINGLE}') {
                                jQuery('.item-label', choiceItemCont).text(choiceItem.label);
                            }
                            else{
                                jQuery('.item-label', choiceItemCont).text(choiceItem);
                            }
                            choiceItemCont.attr('nextquestion',choiceItem.nextQuestion);
                        });
                        jQuery('.choice-items > .choice-item:first', container).remove();

                        jQuery('select.choice-type', container).val(choiceType);

                        break;

                    case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                        var questionPlaceHolder = answerDetails.questionPlaceholder;

                        container = constructQuestionItem(answerDetails.type);

                        jQuery('textarea.place-holder-text', container).attr('placeholder', questionPlaceHolder);

                        break;

                    case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                        var ratingLabels = answerDetails.ratingLabels;
                        var rowLabels = answerDetails.rowLabels;

                        container = constructQuestionItem(answerDetails.type);

                        var first = jQuery('table.scale-table > thead th.rating-label:first', container);
                        var thead = jQuery('table.scale-table > thead tr', container);
                        jQuery.each(ratingLabels, function (idx, ratingLabel) {
                            var ratingLabelCont = first.clone();
                            thead.append(ratingLabelCont);
                            jQuery('div', ratingLabelCont).text(ratingLabel);
                        });
                        jQuery('table.scale-table > thead th.rating-label:first', container).remove();

                        jQuery.each(rowLabels, function (idx, rowLabel) {
                            var rowLabelCont = jQuery('table.scale-table > tbody > tr.scale-row:first', container).clone();
                            jQuery('table.scale-table > tbody > tr.scale-row:first', container).after(rowLabelCont);
                            jQuery('div.row-label', rowLabelCont).text(rowLabel);

                            var original = jQuery('td.rating-weight:first', rowLabelCont);
                            original.find('input[type=radio]').attr('name', i+'_'+idx).val(ratingLabels[ratingLabels.length-1]);
                            for (var k = 1; k < ratingLabels.length; k++) {
                                var clone = original.clone();
                                clone.find('input[type=radio]').attr('name', i+'_'+idx).val(ratingLabels[k-1]);
                                original.after(clone);
                            }
                        });
                        jQuery('table.scale-table > tbody > tr.scale-row:first', container).remove();

                        break;

                    case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                        container = constructQuestionItem(answerDetails.type);
                        var stars = jQuery('.stars', container).empty();
                        for(var i = 0; i < parseInt(answerDetails.nofStars); i++){
                            jQuery('.stars', container).append(jQuery('<div class="col star clickable" seq="'+i+'"></div>').click(function(){
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

//                jQuery('.questionTextContainer div', container).text(item.questionStr);
                container.attr('id',"question"+item.seq);
                container.attr('seq',item.seq);
                jQuery('.question-text', container).html("<span style='font-size:24px;color:grey;'>"+item.questionStr.charAt(0)+"</span>" + item.questionStr.substring(1));
                if(i==0){
                    container.attr('hidden',false)
                }
                ttlQuestions++;
            }

        );

        }

    }

</script>

</head>

<body>
    <div class="module-header">
        <div class="title">Take Survey</div>
    </div>
    <div class="module-content">
        <div class="panel panel-default">
            <div class="panel-heading" style="padding: 15px">
                <div class="media">
                    <div id="surveyLogo" class="pull-left survey-logo" style="background: #4f4f4f url('../images/skin/survey-default-icon.png') no-repeat center center; background-size: 70% 70%;">
                        %{--<img class="img-circle img-responsive" src="${request.contextPath}/respondent/viewSurveyLogo?surveyId=${survey.surveyId}" style="width: 175px; height: 175px; background: url('../images/ticbox/Logo_Placeholder.png') no-repeat scroll center center #F5F5F5">--}%
                        %{--<img class="media-object img-responsive" src="${request.contextPath}/respondent/viewSurveyLogo?surveyId=${survey.surveyId}" alt="" style="width: 100px; height: 100px; background: #4f4f4f url('../images/skin/survey-default-icon.png') no-repeat center; background-size: 70% 70%;">--}%
                        <img class="media-object img-responsive" src="${request.contextPath}/respondent/viewSurveyLogo?surveyId=${survey.surveyId}" alt="">
                    </div>
                    <div class="media-body">
                        <h4 class="media-heading">
                            ${survey.name}
                        </h4>
                        <p>
                            <g:if test="${survey.title}">
                                ${survey.title}
                            </g:if>
                            <g:else>
                                <div class="module-message" style="font-size: inherit">no description available</div>
                            </g:else>
                        </p>
                        <div class="alert alert-info" style="margin-bottom: 0; font-size: 8px; width: 100%">
                            We appreciate your contribution to this survey. By submitting your responds you signify your agreement to our Terms & Conditions.
                            To understand how we treat your data please read the Privacy Policy.
                            Good luck on completing the survey!
                        </div>
                    </div>
                </div>
            </div>
            <div class="surveyItemsContainer enableTooltip panel-body">
            </div>
        </div>

        <div class="" style="padding: 0 0 3em 0;">
            <button id="nextQuestion" class="btn btn-blue-trust btn-md">${g.message(code:'app.next.label')}</button>
            <button id="saveResponse" class="btn btn-blue-trust btn-md">${g.message(code:'app.submit.label')}</button>
            <button id="cancel" class="btn btn-light-oak btn-md" href="${request.contextPath}/respondent/">Cancel</button>
        </div>

        <div class="templates" style="display: none;">

            <div id="questionTemplate" class="surveyItemContainer" hidden="true">
                <div class="row">
                    <div class="seqNumberContainer questionNumber col-xs-1"></div>
                    <div class="questionTextContainer col-xs-11">
                        <span class="question-text"></span>
                        %{--<div rows="3"></div>--}%
                    </div>
                </div>
            </div>

            <div id="answerTemplate-singleText" class="row answerTemplate" type="${Survey.QUESTION_TYPE.FREE_TEXT}">
                <div class="col col-xs-11 col-xs-offset-1">
                    <textarea class="place-holder-text form-control" rows="3" placeholder="${message([code: 'message.type-to-replace-place-holder', default: 'Type here to change this placeholder..'])}"></textarea>
                </div>
            </div>

            <div id="answerTemplate-choice-single" class="row answerTemplate" type="${Survey.QUESTION_TYPE.CHOICE_SINGLE}">
                <div class="choice-items col-xs-11 col-xs-offset-1">
                    <div class="choice-item row">
                        %{--<div class="col col-xs-1" style="text-align: right">--}%
                        <div class="col col-xs-12">
                            <input class="item-check">
                        %{--</div>--}%
                        %{--<div class="col col-xs-11" style="padding-left: 0">--}%
                            <label class="item-label" style="font-weight: normal; margin-bottom: 0">
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <div id="answerTemplate-choice-multiple" class="row answerTemplate" type="${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}">
                <div class="choice-items col-xs-11 col-xs-offset-1">
                    <div class="choice-item row">
                        %{--<div class="col col-xs-1" style="text-align: right">--}%
                        <div class="col col-xs-12">
                            <input class="item-check">
                            %{--</div>--}%
                            %{--<div class="col col-xs-11" style="padding-left: 0">--}%
                            <label class="item-label" style="font-weight: normal; margin-bottom: 0">
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <div id="answerTemplate-scale" class="row answerTemplate" type="${Survey.QUESTION_TYPE.SCALE_RATING}">
                <div class="col col-xs-11 col-xs-offset-1" style="width:auto; overflow-x: auto;">
                    <table class="table scale-table table-bordered table-responsive">
                        <thead>
                            <tr class="scale-head">
                                <th style="text-align: center;"></th>
                                <th class="rating-label" style="text-align: center">
                                    <div></div>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                        <tr class="scale-row">
                            <td>
                                <div class="row-label"></div>
                            </td>
                            <td class="rating-weight" style="text-align: center">
                                <input type="radio" name="rd-1"/>
                            </td>
                            %{--<td></td>--}%
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="answerTemplate-starRating" class="row answerTemplate" type="${Survey.QUESTION_TYPE.STAR_RATING}">
                <div class="line stars col-xs-11 col-xs-offset-1">
                    <div class="col star clickable"></div>
                    <div class="col star clickable"></div>
                    <div class="col star clickable"></div>
                    <div class="col star clickable"></div>
                    <div class="col star clickable"></div>
                </div>
            </div>

        </div>
    </div>

</body>
</html>