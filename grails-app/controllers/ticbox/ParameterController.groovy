package ticbox

class ParameterController {


    def index() {
        def parameters = Parameter.findAll()

        [parameters: parameters]

    }
    def editParameter(){
        Parameter parameter=Parameter.findByCode(params.code)

        [parameter:parameter]
    }

    def submitParameter(){
        try {
            Parameter parameter=Parameter.findByCode(params.parameterCode)
            parameter.value=params.parameterValue

            parameter.save()

            render 'SUCCESS'
        } catch (Exception e) {
            e.printStackTrace()
            render 'FAILED'
        }
        redirect action: 'index'
    }
}
