module AddressesHelper
    
    STATE_ABBRS =      ["al", "ak", "az", "ar", "ca", "co", "ct", "de", "fl", "ga", "hi",
                        "id", "il", "in", "ia", "ks", "ky", "la", "me", "md", "ma", "mi",
                        "mn", "ms", "mo", "mt", "ne", "nv", "nh", "nj", "nm", "ny", "nc",
                        "nd", "oh", "ok", "or", "pa", "ri", "sc", "sd", "tn", "tx", "ut",
                        "vt", "va", "wa", "wv", "wi", "wy"]
                        
    ALL_REGEX =         /.+$/
    NUM_REGEX =         /\d+/
    CO_REGEX =          /c(.|\/)o(.?):? /
    ZIP_REGEX =         /^[0-9]{5}(-[0-9]{4})?/
    ZIP5_REGEX =        /^[0-9]{5}/
    ZIP4_REGEX =        /-[0-9]{4}$/
    PO_BOX_REGEX =      /^((p.o.)|(po)|(p o )|(pmb))? ?box /
    PO_BOX_FULL_REGEX = /^((p.o.)|(po)|(pmb))?( )?box [0-9]+/
    APT_REGEX =         /(( |^)unit ?(#| no.))|(( |^)(ste.|suite))|(( |^)apt.? ?#?)|( #)/
    
    

                        #the street address indicator goes last, to clear anything else out of the line first
                        #Apt/unit #
    INDICATORS =       [{key_label: :unit_name, value_label: :unit_number, key_type: :string,
                         value_type: :integer, key_regex: APT_REGEX, value_regex: NUM_REGEX},
                        #c/o name
                        {value_label: :care_of, value_type: :string, key_regex: CO_REGEX,
                         value_regex: ALL_REGEX},
                        #po box #
                        {value_label: :po_box, value_type: :integer, key_regex: PO_BOX_FULL_REGEX,
                         key_db_regex: PO_BOX_REGEX, value_regex: NUM_REGEX},
                        #street #/name
                        {key_label: :street_number, value_label: :street_name, key_type: :integer,
                         value_type: :string, key_regex: /^\d+/, value_regex: /\D+$/}]
                         
                         # Additional funcionality of above data/method:
                         # if the indicator detection relies on the full key/value pair but the key_match
                         # must still be stored independent of the value, adding a :key_db_regex value
                         # will separate the in-text key from the value
                         # {key_label: :box_name, value_label: :po_box, key_type: :string,
                         #  value_type: :integer, key_regex: PO_BOX_FULL_REGEX,
                         #  key_db_regex: PO_BOX_REGEX, value_regex: NUM_REGEX}
                   
    TEST_STRINGS =     ["Bennett Neale\nBlayze.com\n910 Colorado Blvd.\nSanta Monica, CA 90401", 
                        "Bennett Neale\n910 Colorado Blvd.\nSanta Monica, CA\n90401-543", 
                        "Bennett Neale c/o MuckerLab\n910 Colorado Blvd.\n\#14\nSanta Monica, CA 90401\n", 
                        "Bennett Neale CTO\nBlayze.com\nc/o MuckerLab\n910 Colorado Boulevard\nSanta Monica, CA\n90401:3438",
                        "Andre Ranadive\n164 Isabella Ave.\nAtherton CA 94027",
                        "Allen Rettberg\n1231 N. Ogden Dr. Apt. 6\nWest Hollywood, CA 90046",
                        "ABC COMPANY\n126 MICHIGAN AVE\nP O BOX 30054\nLANSING MI 48909"]
                
    @address_hash = {}
                
#********************DEBUG/TEST ONLY**********************************DEBUG/TEST ONLY**********************
def test_parser
    TEST_STRINGS.each do |s|
        puts parse_address_text(s)
        puts ""
    end
    return true
end
#********************DEBUG/TEST ONLY**********************************DEBUG/TEST ONLY**********************

def parse_address_text(text)        
    #clear variables
    @errors = []
    @address_hash = {}
    
    @address_hash[:text_block] = text
    
    split_address_lines(text)
    
    #****************************DEBUG*********************************************************************
    # puts "address_hash: #{@address_hash}"
    # puts "errors: #{@errors}"
    #****************************DEBUG*********************************************************************
    
    return {address: @address_hash, errors: @errors}
end

def split_address_lines(text)
    addressee = []
    address = {}
    bottom_line = []        

    text_ary = text.split("\n")         #do this separately so we can reference the array later
                                        #without re-creating it
    #iterate through each line individually
    text_ary.each_with_index do |line, i|
        
        #find and extract any indicators
        line = find_indicators(line)
        next if line == nil
        
        # if first line, just put it straight into the name1 variable
        #we're assuming the address is entered with a name
        if i == 0
            @address_hash[:name_1] = line 
            next
        end
        
        line_ary = line.downcase.split
        
        #if the line contains a state abbreviation, it's the last line.
        #this test also eliminates the possibility of an extra newline 
        #at the end of the input string, which could lead to an empty 
        #last array element.
        if (@address_hash[:state] = contains_state_abbr?(line_ary))
            @address_hash[:state] = @address_hash[:state].to_s.upcase
            bottom_line = line_ary
            #check if zip code is on separate line
            #text_ary is the array of the whole text block, not a typo
            if text_ary[i+1] && text_ary[i+1] =~ ZIP_REGEX
                bottom_line << text_ary[i+1]
            end
            
            break
        end
        
        #if we've reached this point, this line is the 2nd (or 3rd) line of the adressee
        addressee << line
    end
    
    #if we reach this point, we've iterated through every line in text_ary
    #if bottom_line is still empty, the state abbreviation was never found
    if bottom_line.empty?
        @errors << "Incorrect state format. Use 2-character abbreviation (i.e. 'CA')"
    else
        parse_bottom_line(bottom_line)
    end
      
    #****************************DEBUG*********************************************************************
    # puts "addressee: #{addressee.inspect}"
    # puts "address: #{address.inspect}"
    # puts "bottom line: #{bottom_line.inspect}"
    #****************************DEBUG*********************************************************************
    
    addressee.each_with_index do |s, i|
        @address_hash["name_#{i+2}".to_sym] = s
        #****************************DEBUG*********************************************************************
        #puts address_hash.inspect
        #****************************DEBUG*********************************************************************
    end
end

def find_indicators(line)
    #****************************DEBUG***************************************DEBUG******************************
    #puts "line outside loop: '#{line}'"
    #****************************DEBUG***************************************DEBUG******************************
    
    #look for 'apt', 'unit', "c/o", etc
    INDICATORS.each do |hash|
        if line.downcase =~ hash[:key_regex]
            key_match = line.downcase.match(hash[:key_regex]).to_s
            key_db_match = key_match.match(hash[:key_db_regex]).to_s.strip if hash[:key_db_regex]
            
            #this has been moved to after the key_db_match setting,
            #in case the regex requires leading/trailing whitespace
            key_match.strip! 
            
            #store the indicator, if there's a place to store it
            #then keep as a string, or convert to integer
            if hash[:key_label]
                if hash[:key_type] == :string
                    @address_hash[hash[:key_label]] = (key_db_match || key_match).split.map{|s| s.capitalize}.join(" ")
                elsif hash[:key_type] == :integer
                    @address_hash[hash[:key_label]] = (key_db_match || key_match).to_i
                end
            end
            
            index = line.downcase.index(key_match)
            
            #make sure the value is after the key
            #example: key=>'#', value=>'/\d+', "3455 Edison Way, #17" should return 17, not 3455
            value_match = line.slice(index..line.size).match(hash[:value_regex]).to_s.strip
            
            if hash[:value_type] == :string
                @address_hash[hash[:value_label]] = value_match.split.map{|s| s.capitalize}.join(" ")
            elsif hash[:value_type] == :integer
                @address_hash[hash[:value_label]] = value_match.to_i
            end
            
            #****************************DEBUG***************************************DEBUG******************************
            # puts "line: '#{line}'"
            # puts "key_match: '#{key_match}'"
            # puts "key_db_match: #{key_db_match}"
            # puts "value_match: '#{value_match}'"
            #****************************DEBUG***************************************DEBUG******************************
            
            #if this was at the end of the address line, chop the 'apt x' off and continue
            #if not return nil so the loop can move to the next line
            if index > 0
                line.slice!(index, line.size)
                #****************************DEBUG***************************************DEBUG******************************
                # puts "index: '#{index}'"
                # puts "line sliced: '#{line}'"
                #****************************DEBUG***************************************DEBUG******************************
            elsif index == 0
                return nil
            end
        end
    end
    return line
end


def parse_street_address(text_ary)
    @address_hash[:street_number] = text_ary[0]
    @address_hash[:street_name] = \
        text_ary[1, address[0].size].map {|s| s.capitalize}.join(" ")
end


def parse_bottom_line(text_ary)
    #****************************DEBUG***************************************DEBUG******************************
    #puts "bottom_line: '#{text_ary}'"
    #****************************DEBUG***************************************DEBUG******************************
    state_index = find_state_abbr(text_ary)
    city = ""
    zip_5 = ""
    zip_4 = ""
    
    #get city name
    state_index.times do |i|
        city += i > 0 ? (" " + text_ary[i].gsub(",", "").capitalize) : text_ary[i].gsub(",", "").capitalize
    end
    @address_hash[:city] = city
    
    #get zipcode
    zip_full = text_ary[state_index + 1]

    unless zip_full =~ ZIP_REGEX
        @errors << "Incorrect zip format. Use format '12345' or '12345-6789'"
    else
        @address_hash[:zip_5] = zip_full.match(ZIP5_REGEX).to_s
        
        #****************************DEBUG*********************************************************************
        #puts "zip_full: '#{zip_full}'"
        #****************************DEBUG*********************************************************************
        
        if zip_full =~ /^[0-9]{5}.+$/ && (zip_4 = zip_full.match(ZIP4_REGEX).to_s) == ""
            @errors << "Incorrect zip suffix format. Proper zip format is: '12345-6789'"
        else
            #discard separator character
            @address_hash[:zip_4] = zip_4.match(/[0-9]{4}/).to_s
        end
    end
end

def find_state_abbr(text_ary=[])
    #returns array index of state abbreviation, nil if not found
    
    #just in case
    text_ary.map! {|s| s.downcase}
    
    #****************************DEBUG***************************************DEBUG******************************
    #puts "bottom_line @find_state: '#{text_ary}'"
    #puts "contains_state: '#{contains_state_abbr?(text_ary)}'"
    #****************************DEBUG***************************************DEBUG******************************
    
    if (abbr = contains_state_abbr?(text_ary))
        text_ary.each_with_index do |s, i|
            return i if s == abbr
        end
    else
        return nil
    end
    
    return nil
end

def contains_state_abbr?(text_ary=[])
    #while this acts as a boolean function, it additionally returns the state abbreviation that is found
    
    #just in case
    text_ary.map! {|s| s.downcase}
    
    #****************************DEBUG***************************************DEBUG******************************
    #puts "state abbrs: '#{STATE_ABBRS}'"
    #****************************DEBUG***************************************DEBUG******************************
    
    #because it's checking the array and not the string, "ms. smith"
    #won't trip the function up
    STATE_ABBRS.each do |s|
        if text_ary.include?(s)
            return s
        end
    end
    
    return nil
end
end
