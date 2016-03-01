# coding: utf-8
class HaddockPlugin < BasePlugin
  def initialize()
    @actions = ['haddock', 'insult', 'addinsult', 'robin', 'hylla', 'addhyllning', 'robidock', 'batman']
    @regexps = []
  end

#  class << self
    def haddock(msg)
      if msg.message.empty?
        h = Haddock.find :first, :order => 'RANDOM()'
      else
        h = Haddock.find :first, :conditions => "insult ilike '%#{msg.message}%'", :order => 'RANDOM()' 
      end
      "%s!" % h.insult.strip if h
    end

    def robin(msg)
      h = Robin.find :first, :order => 'RANDOM()'
      "Holy %s, %s!" % [h.comment, 'Batman'] if h
    end

    def robidock(msg)
      h = Haddock.find :first, :order => 'RANDOM()'
      r = Robin.find :first, :order => 'RANDOM()'
      "Holy %s, %s!" % [r.comment, h.insult.downcase] if r && h
    end

    def batman(msg)
      "I'm batman!"
    end

    def insult(msg)
      return nil unless msg.message 
      return nil if msg.message.empty?
      insultee = msg.message
      ins = Insult.order('RANDOM()').first()
      puts ins.inspect
      if ins.insult.match(/%S/)
        ins.insult.gsub!(/%S/,'%s')
        insultee.upcase!
      end
      ins.insult % insultee if ins
    end

    def addinsult(msg)
      return nil unless msg.message
      insultee = msg.user.nick
      begin
        msg.message % insultee
      rescue
        return nil
      end
      ins = Insult.create :insult => msg.message
      if ins.insult.match(/%S/)
        ins.insult.gsub!(/%S/,'%s')
        insultee.upcase!
      end
      ins.insult % insultee if ins
    end

    def hylla(msg)
      return nil unless msg.message 
      return nil if msg.message.empty?
      ins = Hylla.find :first, :order => 'RANDOM()'
      ins.hyllning % msg.message if ins
    end

    def addhyllning(msg)
      return nil unless msg.message
      return nil unless msg.message=~/.*%s.*/
      ins = Hylla.create :hyllning => msg.message
      ins.hyllning % msg.user.nick
    end
#  end
end
