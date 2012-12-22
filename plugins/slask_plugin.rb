# coding: utf-8
class SlaskPlugin < BasePlugin
  require 'morse'
  require 'shellwords'
  SUBEX = /^s\/.*\/.*\//
  GSUBEX = /^s\/.*\/.*\/g$/
  OMSTART = /omstart,.?$/
  def initialize()
    @actions = ['rand', 'longjmp', 'stop', 'halt', 'tid', 'monday', 'måndag', 'öl', 'oel', /spa+c+e+$/, 'juljmp', 'skrivaao', 'skrivaoaueoeoe', 'punch', 'pick', 'dag', 'morse', 'rovare']
    @regexps = [SUBEX, GSUBEX, OMSTART]
  end

  #class << self
    def action(message)
      case message.action
      when /spa+c+e+$/
        resp = space()
        build_response(resp, message)
      #when 'skrivaao'
#        build_response(['Detta är UTF-8 åäöÅÄÖ.', 'Detta är ISO-8859-15 åäöÅÄÖ.'.encode("ISO-8859-15", "UTF-8")], message) 
      else
        if message.message=~SUBEX
          build_response(sub(message), message)
        elsif message.message=~GSUBEX
          build_response(sub(message, true), message)
        else
          super
        end
      end
    end

    def sub(msg, g=false)
    #  _, f, r, m = msg.message.split('/')
     # return nil unless msg.user.previous[msg.channel]=~/#{f}/
     # r = '' if r.nil?
      resp ="#{msg.user.nick} menade: " 
      #resp+=(msg.user.previous[msg.channel].sub(/#{f}/, r)) unless g
      #resp+=(msg.user.previous[msg.channel].gsub(/#{f}/, r)) if g
      puts "echo #{msg.user.previous[msg.channel].shellescape} | sed -e #{msg.message.shellescape}".strip
      sub=`echo #{msg.user.previous[msg.channel].shellescape} | sed -e #{msg.message.shellescape}`.strip
      return nil if sub == msg.user.previous[msg.channel]
      resp+sub
    #rescue StandardError => e
    #  puts e.message
    #  raise e
    end

    def rovare(msg)
      rovarstr = 's/\([bcdfghjklmnpqrstvwxz]\)/\1o\1/g'
      if msg.message.empty?
        msg.message = rovarstr
        sub(msg)
      else
        resp ="#{msg.user.nick} menade: " 
        puts "echo #{msg.message.shellescape} | sed -e #{rovarstr.shellescape}".strip
        resp+=`echo #{msg.message.shellescape} | sed -e #{rovarstr.shellescape}`.strip
        resp
      end
    end

    def skrivaao(msg)
        ['Detta är UTF-8 åäöÅÄÖ.', 'Detta är ISO-8859-15 åäöÅÄÖ.'.encode("ISO-8859-15", "UTF-8")]
    end

    def skrivaoaueoeoe(msg) 
      "Detta är Danska aaAAøØæÆ"
    end

    def morse(msg)
      if msg.message=~/^[.\- ]+$/
        Morse.decode msg.message
      else
        Morse.encode msg.message
      end
    end

    def dag(message)
      format = message.message.empty? ? "%A" : message.message
      Time.now.strftime format
    end

    def rand(message)
      '4'
    end

    def longjmp(msg)
      'For speed!'
    end
    def juljmp(msg)
      'For speed!'
    end

    def stop(msg)
      'Hammertime!'
    end

    def halt(msg)
      'Hammerzeit!'
    end

    def tid(msg)
      t = Time.now
      t.utc
      t += 3600
      it = (1000*(t.hour+(t.min+t.sec/60.0)/60.0)/24).round
      '@'+it.to_s
    end

    def monday(msg)
      return 'http://youtu.be/s22bwvHQcnc' if Time.now.monday?
      return 'Nope! \o/'
    end
    alias :måndag :monday

    def friday(msg)
      return "It's Friday, Friday. Gotta get down on Friday. Everybody's lookin' forward to the weekend, weekend." if Time.now.friday?
      return "After Friday comes Saturday!" if Time.now.saturday?
      return "Kanske lillfredag..."#"No :("
    end
    alias :fredag :friday

    def punch(msg)
      return "Det är torsdag, klart du ska ha lite punch!" if Time.now.thursday?
      return "Det är visserligen inte torsdag, men lite punch vågar man sig nog på ändå."
    end

    def oel(msg)
      case Time.now.hour
      when 0..17
        'Ikväll blir det väder, perfekt for lite öl!'
      else
        'Ikväll är det tipptopp ölväder!'
      end
    end
    alias :öl :oel

    def space()
      return 'http://spaaaaaaaaaaaaaaaaaaaaaaaccee.com/'
    end

    def pick(msg)
      msg.message.split(' vs ').shuffle.first.strip
    end
#  end
end
