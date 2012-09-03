module TextBlocksHelper
    
    # STATE_ABBRS =  ["al", "ak", "az", "ar", "ca", "co", "ct", "de", "fl", "ga", "hi",
    #                     "id", "il", "in", "ia", "ks", "ky", "la", "me", "md", "ma", "mi",
    #                     "mn", "ms", "mo", "mt", "ne", "nv", "nh", "nj", "nm", "ny", "nc",
    #                     "nd", "oh", "ok", "or", "pa", "ri", "sc", "sd", "tn", "tx", "ut",
    #                     "vt", "va", "wa", "wv", "wi", "wy"]
    #                     
    #     ZIP_REGEX =     /^[0-9]{5}(-[0-9]{4})?/
    #     ZIP5_REGEX =    /^[0-9]{5}/
    #     ZIP4_REGEX =    /[-.:][0-9]{4}$/
    #                     
    #     TEST_STRINGS = ["Bennett Neale\nBlayze.com\n910 Colorado Blvd.\nSanta Monica, CA 90401", 
    #                     "Bennett Neale\n910 Colorado Blvd.\nSanta Monica, CA\n90401-543", 
    #                     "Bennett Neale c/o MuckerLab\n910 Colorado Blvd.\n\#14\nSanta Monica, CA 90401\n", 
    #                     "Bennett Neale CTO\nBlayze.com\nc/o MuckerLab\n910 Colorado Boulevard\nSanta Monica, CA\n90401:3438",
    #                     "Andre Ranadive\n164 Isabella Ave.\nAtherton CA 94027"]
    #                     
    #     #@errors = []
    #                     
    #     #********************DEBUG/TEST ONLY**********************************DEBUG/TEST ONLY**********************
    #     def test_parser
    #         TEST_STRINGS.each do |s|
    #             parse_address_text(s)
    #             puts ""
    #         end
    #         return true
    #     end
    #     #********************DEBUG/TEST ONLY**********************************DEBUG/TEST ONLY**********************
    #     
    #     def parse_address_text(text)        
    #         #clear errors
    #         @errors = []
    #         
    #         address_hash = split_address_lines(text)
    #         
    #         #****************************DEBUG*********************************************************************
    #         puts "address_hash: #{address_hash}"
    #         puts "errors: #{@errors}"
    #         #****************************DEBUG*********************************************************************
    #         
    #         return {address: address_hash, errors: @errors}
    #     end
    #     
    #     def split_address_lines(text)
    #         addressee = []
    #         address = []
    #         bottom_line = []        
    # 
    #         text_ary = text.split("\n")         #do this separately so we can reference the array later
    #                                             #without re-creating it
    #         #iterate through each line individually
    #         text_ary.each_with_index do |line, i|
    #             
    #             line_ary = line.downcase.split
    #             
    #             
    #             #****************************DEBUG*********************************************************************
    #             #puts line_ary.inspect
    #             #****************************DEBUG*********************************************************************
    #             
    #             # if first line, just put it straight into the name1 variable
    #             if i == 0
    #                 addressee[0] = line 
    #                 next
    #             end
    #             
    #             #if line starts with a number, assume it's a street address
    #             if line_ary[0].to_i > 0 && !address[0]
    #                 address[0] = line_ary
    #                 next
    #             end
    #             
    #             #if the line contains a state abbreviation, it's the last line.
    #             #this test also eliminates the possibility of an extra newline 
    #             #at the end of the input string, which could lead to an empty 
    #             #last array element.
    #             if contains_state_abbr?(line_ary)
    #                 bottom_line = line_ary
    #                 #check if zip code is on separate line
    #                 if text_ary[i+1] && text_ary[i+1] =~ ZIP_REGEX
    #                     bottom_line << text_ary[i+1]
    #                 end
    #                 
    #                 break
    #             end
    #             
    #             #if we've reached this point, this line is a 2nd (or 3rd) line
    #             #of either the 'addressee' or the 'address', now we decide which:
    #             if address[0]
    #                 address << line
    #             else
    #                 addressee << line
    #             end
    #         end
    #         
    #         #if we reach this point, we've iterated through every line in text_ary
    #         #if bottom_line is still empty, the state abbreviation was never found
    #         if bottom_line.empty?
    #             @errors << "Incorrect state format. Use 2-character abbreviation (i.e. 'CA')"
    #             return {}
    #         end
    #         
    #         address_hash = parse_bottom_line(bottom_line)
    #         
    #         #****************************DEBUG*********************************************************************
    #         # puts "addressee: #{addressee.inspect}"
    #         # puts "address: #{address.inspect}"
    #         # puts "bottom line: #{bottom_line.inspect}"
    #         #****************************DEBUG*********************************************************************
    #         
    #         addressee.each_with_index do |s, i|
    #             address_hash["name_#{i+1}".to_sym] = s
    #             #****************************DEBUG*********************************************************************
    #             #puts address_hash.inspect
    #             #****************************DEBUG*********************************************************************
    #         end
    #         
    #         address_hash[:street_number] = address[0][0]
    #         address_hash[:street_name] = \
    #             address[0][1, address[0].size].map {|s| s.capitalize}join(" ")
    #         address_hash[:unit_number] = address[1]
    #         
    #         return address_hash
    #     end
    #     
    #     def parse_bottom_line(text_ary)
    #         state_index = find_state_abbr(text_ary)
    #         city = ""
    #         zip_5 = ""
    #         zip_4 = ""
    #         
    #         #get city name
    #         state_index.times do |i|
    #             city += i > 0 ? (" " + text_ary[i].gsub(",", "").capitalize) : text_ary[i].gsub(",", "").capitalize
    #         end
    #         
    #         #get state abbr, upcase it
    #         state = text_ary[state_index].upcase
    #         
    #         #get zipcode
    #         zip_full = text_ary[state_index + 1]
    # 
    #         unless zip_full =~ ZIP_REGEX
    #             @errors << "Incorrect zip format. Use format '12345' or '12345-6789'"
    #         else
    #             zip_5 = zip_full.match(ZIP5_REGEX).to_s
    #             #****************************DEBUG*********************************************************************
    #             #puts "zip_full: '#{zip_full}'"
    #             #****************************DEBUG*********************************************************************
    #             
    #             if zip_full =~ /^[0-9]{5}.+$/ && (zip_4 = zip_full.match(ZIP4_REGEX).to_s) == ""
    #                 @errors << "Incorrect zip suffix format. Discarding."
    #             else
    #                 #discard separator character
    #                 zip_4 = zip_4.match(/[0-9]{4}/).to_s
    #             end
    #         end
    #         
    #         return {city: city, state: state, zip_5: zip_5, zip_4: zip_4}
    #     end
    #     
    #     def find_state_abbr(text_ary=[])
    #         #returns array index of state abbreviation, nil if not found
    #         
    #         #just in case
    #         text_ary.map! {|s| s.downcase}
    #         
    #         if (abbr = contains_state_abbr?(text_ary))
    #             text_ary.each_with_index {|s, i| return i if s == abbr}
    #         else
    #             return nil
    #         end
    #         
    #         return nil
    #     end
    #     
    #     def contains_state_abbr?(text_ary=[])
    #         #while this acts as a boolean function, it additionally returns the state abbreviation that is found
    #         
    #         #just in case
    #         text_ary.map! {|s| s.downcase}
    #         
    #         #because it's checking the array and not the string, "ms. smith"
    #         #won't trip the function up
    #         STATE_ABBRS.each do |s|
    #             if text_ary.include?(s)
    #                 return s
    #             end
    #         end
    #         
    #         return nil
    #     end
    
end