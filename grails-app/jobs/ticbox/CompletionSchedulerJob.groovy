package ticbox

import java.text.SimpleDateFormat


class CompletionSchedulerJob {

    static triggers = {
      // simple repeatInterval: 5000l // execute job once in 5 seconds
      //cron name: 'MyTrigger', cronExpression: "0, 0, 0, *, *, ?"
    }

    def List<Survey> getAllInProgressSurvey() {
        return Survey.findAllByStatus(Survey.STATUS.IN_PROGRESS)
    }

    def execute() {
        // execute job
        /*
        SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy")
        Date today = new Date()

        for (Survey survey : getAllInProgressSurvey()) {
            Date endDate =  formatter.parse(survey.getCompletionDateTo())

            if(today.after(endDate)) {

                survey.status = Survey.STATUS.COMPLETED
                survey.enableStatus = Survey.ENABLE_STATUS.ENABLE

                survey.save(flush: true)


                if(survey.hasErrors()) {
                    System.out.println("hasErrors= " + survey.errors)
                }

            }
        }
        */
    }
}
