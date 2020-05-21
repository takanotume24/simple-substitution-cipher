require "db"
require "sqlite3"

def make_changed
  ('a'..'z').to_a.each_permutation(reuse: true)
end

def string_to_a(string)
  string = string.gsub(".", "")
  string = string.gsub("\"", "")
  string = string.gsub(",", "")
  string = string.gsub("\n", "")
  string = string.gsub("?", "")
  string.split(" ")
end

dict = Hash(String, Int8).new

DB.open "sqlite3://Dictionary.db" do |db|
  db.query "select * from entries;" do |rs|
    puts "#{rs.column_name(0)}"
    rs.each do
      tmp = rs.read
      case tmp
      when String
        dict[tmp.upcase] = 1
      else
        next
      end
    end
  end
end

dict.each do |key, hash|
  puts "#{key},#{hash}"
end

max_score = 0
max_string = ""
alpha = ('A'..'Z').to_a
i = 0

def string_to_2char(string : String) : Array(String)
  array = [] of String

  if string.size < 2
    return array
  end

  string.split("").each_index do |i|
    if i + 2 > string.size
      next
    end
    char_2 = "#{string[i]}#{string[i + 1]}"
    array << char_2
  end
  return array
end

def count_2char(dict : Hash(String, Int32), array : Array(String)) : Hash(String, Int32)
  array.each do |char_2|
    if dict.has_key? char_2
      dict[char_2] += 1
    else
      dict[char_2] = 1
    end
  end
  return dict
end

def count_1char(dict : Hash(String, Int32), array : Array(String)) : Hash(String, Int32)
  array.each do |char|
    if dict.has_key? char
      dict[char] += 1
    else
      dict[char] = 1
    end
  end
  return dict
end

string = <<-STRING
MEYLGVIWAMEYOPINYZGWYEGMZRUUYPZAIXILGVSIZZMPGKKDWOMEPGR
OEIWGPCEIPAMDKKEYCIUYMGIFRWCEGLOPINYZHRZMPDNYWDWOGWITD
WYSEDCEEIAFYYWMPIDWYAGTYPIKGLMXFPIWCEHRZMMEYMEDWOZMGQ
RYWCEUXMEDPZMQRGMEEYAPISDWOFICJILYSNICYZEYMGGJIPRWIWAIHR
UNIWAHRZMUDZZYAMEYFRWCEMRPWDWOPGRWAIOIDWSDMEIGWYMSGM
EPYYEYHRUNYARNFRMSDMEWGOPYIMYPZRCCYZZIOIDWIWAIOIDWEYMPD
YAILMYPMEYMYUNMDWOUGPZYKFRMIMKIZMEIAMGODTYDMRNIWASIKJYAI
SIXSDMEEDZWGZYDWMEYIDPZIXDWODIUZRPYMEYXIPYZGRPDMDZYIZXMG
AYZNDZYSEIMXGRCIWWGMOYM
STRING

# char2_dict = Hash(String,Int32).new
# char_dict = Hash(String,Int32).new

# (string_to_a string).each do |word|
#   array_2char = string_to_2char word
#   char2_dict = count_2char char2_dict, array_2char
# end

# (string_to_a string).each do |word|
#   array_char = word.split("")
#   char_dict = count_1char char_dict, array_char
# end

# pp char2_dict.to_a.sort_by {|k,v| v}.reverse.to_h
# pp char_dict.to_a.sort_by {|k,v| v}.reverse.to_h

# make_changed.each do |table|
while true
  table = ('a'..'z').to_a.shuffle
  string = <<-STRING
JXD FVHJX OZFY MFY JXD WQF
JXD FVHJX OZFY UVMWJDY VR LHDMJ WJHDFLJX. JXD WQF MHLQDY JXMJ JXDHD OMW
LHDMJ SVODH ZF LDFJBDFDWW. \"OD WXMBB XMGD M EVFJDWJ,\" WMZY JXD WQF. RMH
UDBVO, M NMF JHMGDBDY M OZFYZFL HVMY. XD OMW ODMHZFL M OMHN OZFJDH EVMJ.
\"MW M JDWJ VR WJHDFLJX,\" WMZY JXD WQF, \"BDJ QW WDD OXZEX VR QW EMF JMKD JXD
EVMJ VRR VR JXMJ NMF.\" \"ZJ OZBB UD AQZJD WZNSBD RVH ND JV RVHED XZN JV HDNVGD
XZW EVMJ,\" UHMLLDY JXD OZFY. JXD OZFY UBDO WV XMHY, JXD UZHYW EBQFL JV JXD
JHDDW. JXD OVHBY OMW RZBBDY OZJX YQWJ MFY BDMGDW. UQJ JXD XMHYDH JXD OZFY
UBDO YVOF JXD HVMY, JXD JZLXJDH JXD WXZGDHZFL NMF EBQFL JV XZW EVMJ. JXDF, JXD
WQF EMND VQJ RHVN UDXZFY M EBVQY. WQF OMHNDY JXD MZH MFY JXD RHVWJC
LHVQFY. JXD NMF VF JXD HVMY QFUQJJVFDY XZW EVMJ. JXD WQF LHDO WBVOBC
UHZLXJDH MFY UHZLXJDH. WVVF JXD NMF RDBJ WV XVJ, XD JVVK VRR XZW EVMJ MFY
WMJ YVOF ZF M WXMYC WSVJ. \"XVO YZY CVQ YV JXMJ?\" WMZY JXD OZFY. \"ZJ OMW DMWC,\"
WMZY JXD WQF, \"Z BZJ JXD YMC. JXHVQLX LDFJBDFDWW Z LVJ NC OMC.\"
STRING
  score = 0
  ('A'..'Z').to_a.each_index do |original_index|
    string = string.gsub alpha[original_index], table[original_index]
  end

  (string_to_a string).each do |word|
    if dict.has_key? word.upcase
      score += 1
    end
  end

  if score > max_score
    max_string = string
    max_score = score
    puts "====== MAX START ======"
    puts string
    puts score
    puts "====== MAX END ====="
  end
end

puts max_score
puts max_string
