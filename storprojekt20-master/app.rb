require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

enable :sessions

get('/')do
db = SQLite3::Database.new("db/workouts.db")
slim(:"users/login")
end

def set_error(error_message)
    session[:error] = error_message
    slim(:error)
end

get('/error')do

slim(:error)
end

post('/register') do
    db = SQLite3::Database.new("db/workouts.db")
    db.results_as_hash = true
    username= params["username"]
    password= params["password"]
    password_confirmation =params["password_confirmation"]

    result = db.execute("SELECT id FROM users WHERE name=?", [username])
    p result
    if result.empty?
        if password == password_confirmation
            password_digest = BCrypt::Password.create(password)
            p password_digest
            db.execute("INSERT INTO users(name, password) VALUES(?,?)", [username, password_digest])
            redirect('/home')
        else
            p 
            set_error("PASS DONT MATCH MAAN")
            redirect('/error')
        end
    else
        p 
        set_error("username nalready exist")
        redirect('/error')
    end
            
end

post('/login') do
    db = SQLite3::Database.new("db/workouts.db")
    db.results_as_hash = true
    username= params["username"]
    password1= params["password"]
    result1 = db.execute("SELECT id, password FROM users WHERE name=?", [username])

    if result1.empty?
        set_error("finns ej bror")
        redirect('/error')
    end

    user_id = result1.first["id"]
    password = result1.first["password"]
    if BCrypt::Password.new(password)==password1
        session[:user_id] = user_id
        redirect('/home')
    else
        set_error("fel uppgifter bror")
        redirect('/error')
    end
end

get('/home') do
    user_id = session[:user_id]
    db = SQLite3::Database.new("db/workouts.db")
    db.results_as_hash = true
    result = db.execute("
        SELECT workouts.id, workouts.moves_id, workouts.sets, workouts.reps,
        moves.name, workouts.program_id, program.name1, program.id
        FROM workouts 
        INNER JOIN moves ON workouts.moves_id = moves.id 
        INNER JOIN program ON workouts.program_id = program.id
        WHERE workouts.user_id = ? 
        AND program.id = workouts.program_id" , user_id)
        
    
    
    names= db.execute("SELECT * FROM program")
    p names
    slim(:"workouts/home",locals:{info:result, name:names})
end

get('/workouts/:id/show') do
    user_id = session[:user_id]
    db = SQLite3::Database.new("db/workouts.db")
    db.results_as_hash = true
    program_id1 = params["id"].to_i

    workout = db.execute("SELECT workouts.id, workouts.moves_id, workouts.sets, workouts.reps,
        moves.name, workouts.program_id FROM workouts INNER JOIN moves ON workouts.moves_id = moves.id
        WHERE workouts.program_id = ? AND workouts.user_id = ?", program_id1, user_id)

 
        
    slim(:"workouts/show",locals:{show:workout})
end


get('/create') do
    user_id = session[:user_id]
    db = SQLite3::Database.new("db/workouts.db")
    db.results_as_hash = true
    result0=db.execute("SELECT * FROM moves")
    slim(:"workouts/create_w",locals:{moves:result0})
end

post('/create_workout')do
user_id = session[:user_id]
prog_name = params["prog_name"].to_s


info= params["info"]
moves= params["moves"]
moves1= params["moves1"]
moves2= params["moves2"]
moves3= params["moves3"]

sets=params["sets"]
sets1=params["sets1"]
sets2=params["sets2"]
sets3=params["sets3"]

reps=params["reps"]
reps1=params["reps1"]
reps2=params["reps2"]
reps3=params["reps3"]

movesarr= []
movesarr << moves
movesarr << moves1
movesarr << moves2
movesarr << moves3

setsarr = []
setsarr <<sets
setsarr <<sets1
setsarr <<sets2
setsarr <<sets3

repsarr=[]
repsarr<<reps
repsarr<<reps1
repsarr<<reps2
repsarr<<reps3



db = SQLite3::Database.new("db/workouts.db")
db.results_as_hash = true

db.execute("INSERT INTO program (name1, user_id) VALUES (?,?)", [prog_name, user_id])
p_id=db.execute("SELECT id FROM program WHERE name1=?", prog_name)
p p_id
i=0

new_arr = []

p_id.each do |e|
    new_arr << e['id']
end



movesarr.each do |el|
db.execute("INSERT INTO workouts (moves_id, sets, reps, user_id, program_id) VALUES (?,?,?,?,?)", [el, setsarr[i], repsarr[i], user_id, new_arr])
i=i+1
p user_id
end


redirect('/home')
end

post('/update_name') do
    db = SQLite3::Database.new("db/workouts.db")
    db.results_as_hash = true
    user_id = session[:user_id]
    newname = params["new_username"]

    db.execute("UPDATE users SET name = ? WHERE id = ?", newname, user_id)
    redirect('/home')
end

post('/:id,:program_id/delete') do
    item_id = params["id"].to_i
    
    program_id = params["program_id"].to_i

    p program_id
    db = SQLite3::Database.new("db/workouts.db")
    db.results_as_hash = true
    db.execute("DELETE FROM workouts WHERE id = ?", item_id)

    pro_id=db.execute("SELECT program_id FROM workouts WHERE program_id = ?", program_id)
    
    
    new_arr1 = []
    pro_id.each do |a|
        new_arr1 << a['program_id']
    end

    if pro_id == []
        db.execute("DELETE FROM program WHERE id = ?", program_id)
    end


    redirect('/workouts/:id/show')
end