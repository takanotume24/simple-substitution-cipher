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

  string.chars.each_index do |i|
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
#   array_char = word.chars
#   char_dict = count_1char char_dict, array_char
# end

# pp char2_dict.to_a.sort_by {|k,v| v}.reverse.to_h
# pp char_dict.to_a.sort_by {|k,v| v}.reverse.to_h

matched_char_dict = Hash(Char, Int32).new
miss_count = 0
clear_count = 0
# make_changed.each do |table|
while true
  table = Hash(Char, Char).new
  original_table = ('A'..'Z').to_a
  
  if matched_char_dict.size > 0
    matched_char_dict.each do |k,v|
      original_table.delete k.upcase
      table[k.upcase] = k
    end
  end

  shuffled_table = original_table.shuffle
  original_table.each_index do |i|
    table[original_table[i]] = shuffled_table[i].downcase
  end

  

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

  table.each do |k,v|
    string = string.gsub k, v
  end

  (string_to_a string).each do |word|
    if dict.has_key? word.upcase
      score += 1
      word.chars.each do |char|
        matched_char_dict[char] = 0
      end
    end 
  end

  if score > max_score
    max_string = string
    max_score = score
    miss_count -= 100000
    puts "====== MAX START ======"
    puts string
    puts score
    puts matched_char_dict
    puts table
    puts "====== MAX END ====="
  else
    miss_count += 1
    if miss_count > 1000
      matched_char_dict = matched_char_dict.clear
      miss_count = 0
      clear_count += 1
      print "#{clear_count} times cleard. \r"
    end
  end

end

puts max_score
puts max_string
