require 'mechanize'

def date
  Time.new.strftime('%d')
end
def month
  Time.new.strftime('%m')
end

def all_script_down(m, d)
  agent = Mechanize.new
  agent.get('http://www.pbs.org/newshour/newshour_index.html').links.each do |link|						#ù �������� ��� ��ũ�� ���ʴ�� ��ĵ
    if link.to_s != 'Intel' && link.uri.to_s =~ /#{m}-#{d}.html/								#��ũ�̸��� ��������, ��ũ url�� ��¥+html�ΰ�
      puts 'downloading' + link.uri.to_s.gsub(/[\\\/\:\*\?\"\<\>\|]/, '').gsub(/http.*june11/,'')				#���� ��Ȳ ����Ʈ
      open(link.uri.to_s.gsub(/[\\\/\:\*\?\"\<\>\|]/, '').gsub(/http.*june11/,'').gsub(/.html/,'')+'.txt', 'w') do |f|		#��ũ���� �����̸� ����
        agent.get(link.uri.to_s).search('//div[@class="copy"]/p').map(&:inner_html).each do |contents|				#��ũ��Ʈ �о����
          f.write(contents.gsub('<strong>','\n').gsub('</strong>',''))								#��ũ��Ʈ ���Ͽ� ����
        end
      end
      a = 1															#ù��° ��ũ�� mp3��ũ�̹Ƿ�
      agent.get(link.uri.to_s).links.each do |link2|										#���� ���� ������ ��� ��ũ ��ĵ
        if link2.to_s != 'Intel' && link2.uri.to_s =~ /.mp3/ && a == 1								#����X, mp3����, ù��° ��ũ
          open(link.uri.to_s.gsub(/[\\\/\:\*\?\"\<\>\|]/, '').gsub(/http.*june11/,'').gsub(/.html/,'')+'.mp3', 'wb') do |f|	#�����̸� ����
            f.write(Mechanize.new.click(link2).body)										#mp3�ٿ�
            a = 2														#���̻� �� �������� ���ϴٿ� ����
          end
        end
      end
    end
  end
end

all_script_down(date().to_s, month().to_s)