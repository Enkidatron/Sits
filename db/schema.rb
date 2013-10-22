# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131022172505) do

  create_table "game_user_joins", :force => true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.boolean  "moderator"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "owner"
  end

  create_table "games", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "open",        :default => true
    t.integer  "turn",        :default => 0,    :null => false
    t.integer  "phase",       :default => 0,    :null => false
  end

  create_table "ship_classes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "base_cost"
    t.integer  "officers"
    t.integer  "enlisted"
    t.integer  "marines"
    t.text     "small_craft"
    t.integer  "recon_drones"
    t.text     "fore_fcon"
    t.integer  "fore_mag"
    t.text     "fore_missiles"
    t.text     "fore_energy"
    t.text     "fore_cm"
    t.text     "fore_pd"
    t.integer  "fore_decoy"
    t.text     "aft_fcon"
    t.integer  "aft_mag"
    t.text     "aft_missiles"
    t.text     "aft_energy"
    t.text     "aft_cm"
    t.text     "aft_pd"
    t.integer  "aft_decoy"
    t.text     "port_fcon"
    t.integer  "port_mag"
    t.text     "port_missiles"
    t.text     "port_energy"
    t.text     "port_cm"
    t.text     "port_pd"
    t.integer  "port_decoy"
    t.text     "star_fcon"
    t.integer  "star_mag"
    t.text     "star_missiles"
    t.text     "star_energy"
    t.text     "star_cm"
    t.text     "star_pd"
    t.integer  "star_decoy"
    t.integer  "scale"
    t.integer  "core_armor"
    t.text     "star_sidewall"
    t.text     "port_sidewall"
    t.text     "brg"
    t.text     "flg"
    t.integer  "lif"
    t.integer  "com"
    t.text     "ecm"
    t.text     "piv"
    t.text     "rol"
    t.integer  "fwd"
    t.integer  "aft"
    t.text     "thrust"
    t.integer  "hyp"
    t.integer  "hull"
    t.text     "si"
    t.text     "repair_parties"
    t.text     "range_bands"
    t.text     "cost_adjusters"
    t.string   "faction"
    t.string   "classification"
    t.integer  "decoy_strength"
  end

  create_table "ships", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.integer  "game_id"
  end

  add_index "ships", ["game_id"], :name => "index_ships_on_game_id"
  add_index "ships", ["user_id"], :name => "index_ships_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "name"
    t.boolean  "admin",                  :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
