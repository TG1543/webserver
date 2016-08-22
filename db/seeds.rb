# Create role

Role.create( value: "Administrator")
Role.create( value: "Investigador Principal")
Role.create( value: "Investigador")
Role.create( value: "Laboratorista")
Role.create( value: "Usuario")

#Create state
State.create(value: "Activo")
State.create(value: "Inactivo")

# Create administrador
user = User.create( email: 'administrador@tg.com',
                    password: '1234567',
                    password_confirmation: '1234567',
                    name: 'administrador',
                    role_id: 1,
                    active: true )
# Create investigador_principal
user = User.create( email: 'investigador_principal@tg.com',
                    password: '1234567',
                    password_confirmation: '1234567',
                    name: 'investigador_principal',
                    role_id: 2,
                    active: true )
# Create investigador_principal
user = User.create( email: 'investigador@tg.com',
                    password: '1234567',
                    password_confirmation: '1234567',
                    name: 'investigador',
                    role_id: 3,
                    active: true )
