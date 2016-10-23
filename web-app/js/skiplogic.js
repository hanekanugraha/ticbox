var SkipLogicSettings = function(questionJsId) {
    this.questionJsId = questionJsId;

    this.answers = [];
    this.usedAnswerIdxs = [];

    this.allOtherQuestionJsIds = [];    
    this.usedQuestionJsIds = [];
    
    this.masterTr = null;
    this.init();
};

// private
SkipLogicSettings.prototype.getQuestionInfo = function(questionJsId) {
    return {
        no: $('#' + questionJsId).attr('seq'),
        text: $('#'+questionJsId+' .questionTextContainer textarea').val()
    }
};

// private
SkipLogicSettings.prototype.addAndRenderSkipLogicRule = function(answerIdx, questionJsId) {
    var scope = this;

    var answerText = this.answers[answerIdx];
    var questionInfo = this.getQuestionInfo(questionJsId);

    var tr = this.masterTr.clone().show();
    $('td:eq(0)', tr).text(answerText);
    $('td:eq(0)', tr).attr('data-answerIdx', answerIdx);
    $('td:eq(2)', tr).text('Question #' + questionInfo.no);
    
    $('td:eq(2)', tr).attr('title', questionInfo.text);
    $('td:eq(2)', tr).attr('data-nextQuestionJsId', questionJsId);

    $('#skipLogic-existingRuleDisplay').append(tr);

    tr.on('click', '.skipLogic-removeBtn', function() {
        // Restore the value
        var answerIdx = $('td:eq(0)', tr).attr('data-answerIdx');
        var nextQuestionJsId = $('td:eq(2)', tr).attr('data-nextQuestionJsId');

        scope.usedAnswerIdxs.splice(scope.usedAnswerIdxs.indexOf(answerIdx), 1);
        scope.usedQuestionJsIds.splice(scope.usedAnswerIdxs.indexOf(nextQuestionJsId), 1);

        scope.render();
    });
};

SkipLogicSettings.prototype.render = function() {
    var scope = this;

    $('#skipLogic-existingRuleDisplay').empty();

    // Render existing rules
    $.each(this.usedQuestionJsIds, function(index, questionJsId) {
        var answerIdx = scope.usedAnswerIdxs[index];
        scope.addAndRenderSkipLogicRule(answerIdx, questionJsId);
    });

    // Render form
    $('#skipLogic-questionText').text(this.getQuestionInfo(this.questionJsId)['text']);

    $('#skipLogic-answerSelect').empty();
    $.each(this.answers, function(index, answerText) {
        if (!scope.usedAnswerIdxs.includes(index)) {
            $('#skipLogic-answerSelect').append("<option value="+index+">"+answerText+"</option>");
        }
    });

    $('#skipLogic-nextQuestionSelect').empty();
    $.each(this.allOtherQuestionJsIds, function(index, questionJsId) {
        var qInfo = scope.getQuestionInfo(questionJsId)
        $('#skipLogic-nextQuestionSelect').append("<option value=" + questionJsId + ">" + qInfo.no + ". " + qInfo.text + "</option>");
    });
};

// private
SkipLogicSettings.prototype.extractAllCurrentAnswers = function(questionContainer) {
    var scope = this;
    questionContainer.find('.choice-item :text').each(function(index) {
        scope.answers.push($(this).val());
    });
};

// private
SkipLogicSettings.prototype.extractExistingRules = function(questionContainer) {
    var scope = this;
    // For each answer of this question, find if it has next question
    questionContainer.find('.choice-item :text').each(function(answerIdx) {
        var nextQuestionJsId = $(this).attr('data-nextQuestionJsId');
        if (nextQuestionJsId) {
            scope.usedQuestionJsIds.push(nextQuestionJsId);
            scope.usedAnswerIdxs.push(answerIdx);
        }
    });
};

// private 
SkipLogicSettings.prototype.init = function() {
    var scope = this;

    var questionContainer = $('#' + this.questionJsId + '');

    // Initial form preparation
    this.masterTr = $('#skipLogic-existingRuleDisplay tr:eq(0)');
    this.masterTr.hide();

    this.extractAllCurrentAnswers(questionContainer);
    this.extractExistingRules(questionContainer);

    // Data to show in the form box ---------------------
    // Get list of other questions
    var currentQuestionJsId = questionContainer.attr('id');
    this.allOtherQuestionJsIds = [];
    $('.surveyItemContainer').each(function() {
        var questionJsId = $(this).attr('id');
        if (questionJsId != currentQuestionJsId && !questionJsId.endsWith('Template')
                            /*&& !usedQuestionJsIds.includes(questionJsId) boleh reuse? */) {
            scope.allOtherQuestionJsIds.push(questionJsId);
        }
    });

    // Event handling -----------------------
    $('#skipLogic-addBtn').unbind('click'); // Remove old event
    $('#skipLogic-addBtn').click(function() {
        var answerIdx = $('#skipLogic-answerSelect').val();
        var nextQuestionJsId = $('#skipLogic-nextQuestionSelect').val();

        scope.usedAnswerIdxs.push(answerIdx);
        scope.usedQuestionJsIds.push(nextQuestionJsId);

        // Modify existing displayed rules
        scope.addAndRenderSkipLogicRule(answerIdx, nextQuestionJsId);

        // Modify form (decrease options)
        $('#skipLogic-answerSelect option:selected').remove();
    });
};

SkipLogicSettings.prototype.onSave = function() {
    var scope = this;
    var questionContainer = $('#' + this.questionJsId + '');

    // Remove all first
    $('.choice-item :text', questionContainer).removeAttr('data-nextQuestionJsId');

    // Add to the original form
    $.each(this.usedQuestionJsIds, function(index, questionJsId) {
        var answerIdx = scope.usedAnswerIdxs[index];
        $('.choice-item :text:eq(' + answerIdx + ')', questionContainer).attr('data-nextQuestionJsId', questionJsId);
    });
};

function questionJsIdToSeq(id) {
    if (id) {
        return $('#' + id).attr('seq');
    } else {
        return null;
    }
}

function seqToQuestionJsId(seq) {
    if (seq) {
        return $('div[seq=' + seq + ']').attr('id');
    } else {
        return null;
    }
}


/* 
Usage: 

jQuery('.surveyItemActions .question-settings', questionComp).click(function() {
    
});

jQuery('.item-label', choiceItemCont).attr('data-nextQuestionJsId', seqToQuestionJsId(choiceItem.nextQSeq));

*/