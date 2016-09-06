# Create roles
Role.create( value: "Administrator")
Role.create( value: "Investigador Principal")
Role.create( value: "Investigador")
Role.create( value: "Laboratorista")
Role.create( value: "Usuario")

#Create states
State.create(value: "Activo")
State.create(value: "Cancelado")

#Create results
Result.create(value: "Exitoso")
Result.create(value: "Fracaso")

#Create equipments
Equipment.create(active: true,name: "Equipo1",serial_number: "A1234")
Equipment.create(active: false, name: "Equipo2",serial_number: "B1234")
Equipment.create(active: true, name: "Equipo2",serial_number: "C1234")

#Create Parameters
Parameter.create(name: "Parametro1")
Parameter.create(name: "Parametro2")
Parameter.create(name: "Parametro3")
Parameter.create(name: "Parametro4")
Parameter.create(name: "Parametro5")


#Create administrador
user = User.create( email: 'administrador@tg.com',
                    password: '1234567',
                    password_confirmation: '1234567',
                    name: 'administrador',
                    role_id: 1,
                    active: true )
#Create investigador_principal
user = User.create( email: 'investigador_principal@tg.com',
                    password: '1234567',
                    password_confirmation: '1234567',
                    name: 'investigador_principal',
                    role_id: 2,
                    active: true )
#Create investigador
user = User.create( email: 'investigador@tg.com',
                    password: '1234567',
                    password_confirmation: '1234567',
                    name: 'investigador',
                    role_id: 3,
                    active: true )

#Create project
Project.create( user_id: 2,
                name: "Proyecto1",
                state_id: 1,
                description: "Descripcion del proyecto1" )

#Create experiments
Experiment.create(project_id: 1,
                  description: "Descripcion del experimento1",
                  state_id: 1,
                  result_id: 1)
Experiment.create(project_id: 1,
                  description: "Descripcion del experimento2",
                  state_id: 1,
                  result_id: nil )
Experiment.create(project_id: 1,
                  description: "Descripcion del experimento3",
                  state_id: 1,
                  result_id: 2)

#Create iteraions
i = Iteration.create( experiment_id: 1, started_at: Date.today-3)
    i.binnacles.create(comment: "Comentario1.1")
    i.binnacles.create(comment: "Comentario2.1")
    i.binnacles.create(comment: "Comentario3.1")
i = Iteration.create( experiment_id: 2,started_at: Date.today)
    i.binnacles.create(comment: "Comentario1.2")
    i.binnacles.create(comment: "Comentario2.2")
    i.binnacles.create(comment: "Comentario3.2")
i = Iteration.create( experiment_id: 2,started_at: Date.today)
    i.binnacles.create(comment: "Comentario1.3")
    i.binnacles.create(comment: "Comentario2.3")
    i.binnacles.create(comment: "Comentario3.3")
