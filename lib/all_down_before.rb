require 'mechanize'

def all_script_down(m, d)
  agent = Mechanize.new
  agent.get('http://www.pbs.org/newshour/newshour_index.html').links.each do |link|						//ù ������ ���� ��� ��ũ�� ���ʴ�� ��ĵ
    if link.to_s != 'Intel' && link.uri.to_s =~ /#{m}-#{d}.html/								//���� ��¥ ��ũ��Ʈ ��ũ���� Ȯ��
      open(link.uri.to_s.gsub(/[\\\/\:\*\?\"\<\>\|]/, '').gsub(/http.*june11/,'').gsub(/.html/,'')+'.txt', 'w') do |f|		//���ϸ� �����ϱ�
        agent.get(link.uri.to_s).search('//div[@class="copy"]/p').map(&:inner_html).each do |contents|				//script �о����
          f.write(contents.gsub('<strong>','').gsub('</strong>',''))								//���Ͽ� script����
        end
      end
      a = 1															//ù��° ��ũ�� ���������� mp3����
      agent.get(link).links.each do |link2|											//������������ ��� ��ũ�� ���ʴ�� ��ĵ
        if link2.uri.to_s =~ /.mp3/ && a == 1											//mp3���Ͽ� ���� ��ũ�̰� ù��°���� Ȯ��
          open(link2.uri.to_s.gsub(/[\\\/\:\*\?\"\<\>\|]/, '').gsub(/http.*media/,''), 'wb') do |f|				//���ϸ������ϱ�
            f.write(Mechanize.new.click(link2).body)										//mp3���� ����
            a = 2														//�̴������� mp3���� ���� ����
          end
        end
      end
    end
  end
end