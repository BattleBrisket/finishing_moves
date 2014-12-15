module FinishingMoves

  Dir[File.dirname(__FILE__) + '/finishing_moves/*.rb'].each do |file|
    require file
  end

end
