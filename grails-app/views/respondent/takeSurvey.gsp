<%@ page import="ticbox.Survey" contentType="text/html;charset=UTF-8" %>
<html>
<head>
<meta name="layout" content="respondent"/>
<title></title>

<style type="text/css">

.surveyItemsContainer input, .surveyItemsContainer textarea, .surveyItemsContainer select {
    margin: 0;
}

.surveyItemsContainer input[type=text], .surveyItemsContainer textarea {
    width: 500px;
}

.surveyItemContainer {
    margin-bottom: 10px;
    clear: right;
}

.surveyItemContainer .seqNumberContainer {
    width: 40px;
    vertical-align: top;
    text-align: right;
    padding-right: 5px;
}

.questionNumber {
    font-size: 24px;
    font-weight: bold;
    color: #97b11a;
}

.surveyItemContainer table {
    margin-bottom: 0;
}

.surveyItemContainer .table th, .surveyItemContainer .table td {
    padding: 5px 1px;
}

.answerTemplate {
    margin: 0 0 0 45px;
}

.star {
    background:transparent url('../images/ticbox/question_BasicState.png');
    background-position: 52px -10px;
    width: 52px; height: 52px;
}

.stars:hover .star, .star.active{
    background:transparent url('../images/ticbox/question_ActiveState.png');
    background-position: 52px -10px;
}

.star:hover ~ .star, .star.basic{
    background:transparent url('../images/ticbox/question_BasicState.png');
    background-position: 52px -10px !important;
}

</style>

<script type="text/javascript">

    var ttlQuestions = 0;

    jQuery(function () {

        jQuery('.enableTooltip').tooltip({
            selector: "button[data-toggle=tooltip]"
        });

        jQuery('#saveResponse').click(function () {

            var questionItems = buildSurveyResponseMap();
            saveResponse(questionItems, this);

        });

        jQuery('#surveyTitle').text('${survey.title}');

        jQuery.getJSON('${request.contextPath}/respondent/getSurvey', {surveyId: '${survey.surveyId}'}, function (questionItems) {

            loadSurvey(questionItems);

        });

    });

    function constructQuestionItem(type, subtype) {
        var answerComp = null;

        var changeTypeIconClass = '';

        switch (type) {

            case '${Survey.QUESTION_TYPE.CHOICE}' :

                answerComp = jQuery('#answerTemplate-choice').clone().removeAttr('id');

                if (subtype == 'single') {
                    jQuery('.item-check', answerComp).attr('type', 'radio');
                } else if (subtype == 'multiple') {
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

                case '${Survey.QUESTION_TYPE.CHOICE}' :

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

                    answerDetails['nofStars'] = jQuery('.stars .star:not(.basic)', container).length;
                    alert(answerDetails['nofStars']);
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

                    case '${Survey.QUESTION_TYPE.CHOICE}' :

                        var choiceItems = answerDetails.choiceItems;
                        var choiceType = answerDetails.choiceType;

                        container = constructQuestionItem(answerDetails.type, choiceType);

                        jQuery.each(choiceItems, function (j, choiceItem) {
                            var choiceItemCont = jQuery('.choice-items > .choice-item:first', container).clone();
                            choiceItemCont.find('.item-check').attr('name', i);
                            choiceItemCont.find('.item-check').val(choiceItem);
                            jQuery('.choice-items', container).append(choiceItemCont);
                            jQuery('.item-label', choiceItemCont).text(choiceItem);
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
                            jQuery('.stars', container).append(jQuery('<div class="col star clickable" seq="'+i+'"></div>'));
                        }

                        jQuery('.star', stars).click(function(){
                            var seq = parseInt(jQuery(this).attr('seq'));
                            jQuery('.star', stars).each(function(idx){
                                if(idx <= seq){
                                    jQuery(this).removeClass('basic');
                                    jQuery(this).addClass('active');
                                }else{
                                    jQuery(this).addClass('active');
                                    jQuery(this).addClass('basic');
                                }
                            });
                        });

                        break;

                }

                jQuery('.questionTextContainer div', container).text(item.questionStr);

            });

        }

    }

</script>

</head>

<body>

<div class="line rowLine10">
    <div class="col col10">
        <div id="surveyLogo"
             style="width: 250px; height: 150px; background: #f5f5f5 url('../images/ticbox/Logo_Placeholder.png') no-repeat center">
            <img src="${request.contextPath}/respondent/viewSurveyLogo?surveyId=${survey.surveyId}"
                 style="width: 250px; height: 150px">
        </div>
    </div>

    <div class="col" style="width: 400px; height: auto; vertical-align: bottom; display: inline-block; color: #97b11a; padding-top: 80px;">
        <h1 id="surveyTitle" style="width: 350px; display: inline-block; resize: none;"></h1>
    </div>
</div>

<br />

<div class="surveyItemsContainer enableTooltip line10">

</div>

<br />

<div class="line" style="padding: 0 0 3em 1em;">
    <button id="saveResponse" class="btn btn-green-city-large btngreen">${g.message(code:'app.submit.label')}</button>
</div>

<div class="templates" style="display: none;">

    <div id="questionTemplate" class="surveyItemContainer line rowLine10">

        <div class="line rowLine2">
            <div class="seqNumberContainer questionNumber col"></div>

            <div class="questionTextContainer col col5">
                <div rows="3"></div>
            </div>
        </div>

    </div>

    <div id="answerTemplate-singleText" class="answerTemplate line rowLine2" type="${Survey.QUESTION_TYPE.FREE_TEXT}">
        <div class="col">
            <textarea class="place-holder-text" rows="3" placeholder="${message([code: 'message.type-to-replace-place-holder', default: 'Type here to change this placeholder..'])}"></textarea>
        </div>
    </div>

    <div id="answerTemplate-choice" class="answerTemplate line rowLine2" type="${Survey.QUESTION_TYPE.CHOICE}">
        <div class="choice-items line">
            <div class="choice-item line rowLine2">
                <div class="col col5">
                    <input class="item-check">
                </div>

                <div class="col col5 ">
                    <div class="item-label">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="answerTemplate-scale" class="answerTemplate line rowLine2" type="${Survey.QUESTION_TYPE.SCALE_RATING}">
        <div class="col" style="height:auto; overflow-x: auto; max-width: 720px;">
            <table class="table scale-table">
                <thead>
                <tr class="scale-head">
                    <th style="text-align: center; width: 100px;">&nbsp;</th>
                    <th class="rating-label" style="text-align: center">
                        <div style="width: 100px; padding: 1px;"></div>
                    </th>
                </tr>
                </thead>
                <tbody>
                <tr class="scale-row">
                    <td style="max-width: 100px;">
                        <div class="row-label" style="width: 100px; padding: 1px;"></div>
                    </td>
                    <td class="rating-weight" style="text-align: center">
                        <input type="radio" name="rd-1"/>
                    </td>
                    <td></td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div id="answerTemplate-starRating" class="answerTemplate line rowLine2" type="${Survey.QUESTION_TYPE.STAR_RATING}">
        <div class="line stars">
            <div class="col star clickable"></div>
            <div class="col star clickable"></div>
            <div class="col star clickable"></div>
            <div class="col star clickable"></div>
            <div class="col star clickable"></div>
        </div>
    </div>

</div>

</body>
</html>