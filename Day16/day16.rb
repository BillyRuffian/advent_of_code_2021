value = File.read('input.txt').chomp

data = value.chars.map { |c| sprintf('%04b', c.to_i(16)) }.join

LITERAL = 4

LENGTH_INDICATOR_MODE = 0
SUBPACKET_INDICATOR_MODE = 1

OPERATORS = {
  sum: 0,
  product: 1,
  min: 2,
  max: 3,
  greater_than: 5,
  less_than: 6,
  equal: 7
}

def header(data)
  packet_data = data.clone
  version = packet_data.slice!(0,3).to_i(2)
  type_id = packet_data.slice!(0,3).to_i(2)

  return version, type_id, packet_data
end

def literal(data)
  packet_data = data.clone
  result = []
  group_counter = 0
  packet_data.chars.each_slice(5) do |group|
    group_value = group[1..4]
    result << group_value
    group_counter += 1
    break if group.first == '0'
  end

  return result.join.to_i(2), packet_data[5*group_counter..]
end

def operator_mode(data)
  packet_data = data.clone
  mode = packet_data.slice!(0).to_i(2)

  length = if mode == LENGTH_INDICATOR_MODE
             packet_data.slice!(0,15).to_i(2)
           else
             packet_data.slice!(0,11).to_i(2)
           end

  return mode, length, packet_data
end

def subpacket(operator, mode, length, data)
  results = []
  versions = []
  result = 0

  if mode == LENGTH_INDICATOR_MODE
    subpart = data.slice!(0, length)
    while !subpart.empty?
      result = packet(subpart)
      results << result[:result]
      versions << result[:version]
      subpart = result[:data]
    end
  else
    length.times do
      parsed = packet(data)
      results << parsed[:result]
      versions << parsed[:version]
      data = parsed[:data]
    end
  end

  result = case operator
           when OPERATORS[:sum] then results.sum 
           when OPERATORS[:product] then results.inject(&:*)
           when OPERATORS[:min] then results.min 
           when OPERATORS[:max] then results.max 
           when OPERATORS[:greater_than] then results[0] > results[1] ? 1 : 0
           when OPERATORS[:less_than] then results[0] < results[1] ? 1 : 0
           when OPERATORS[:equal] then results[0] == results[1] ? 1 : 0
           end
  return {result: result, version: versions.sum, data: data}
end

def packet(data, versions = [])
  return if data.empty? || data.chars.all?('0')
  
  version, type_id, data = header(data)
  versions << version

  if type_id == LITERAL
    literal, data = literal(data)
    {result: literal, version: versions.sum, data: data }
  else
    mode, length, data = operator_mode(data)
    subpacket(type_id, mode, length, data)
  end

    # subpacket(type_id, mode, )

    # mode, data = operator_mode(data)
    # if mode == LENGTH_INDICATOR_MODE
    #   subpacket_bits = data.slice!(0,15).to_i(2)
    #   puts "Subpacket bit length #{subpacket_bits}"
    #   packet(data, versions)
    # else
    #   subpacket_count = data.slice!(0,11).to_i(2)
    #   puts "Subpacket count #{subpacket_count}"
    #   packet(data, versions)
    # end
  # end

end

pp ">>> #{packet(data)}"

# puts "\nsum of versions = #{versions.sum}"