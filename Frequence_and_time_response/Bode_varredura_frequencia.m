close all 
clear all

wr = 25:0.5 :33;
tam = length(wr);

for j=1:tam

posicao = identificaBode(wr(j));

max = length(posicao);

if posicao(max-1)>posicao(max)  %encontra primeiro um maximo
i = max;
  while posicao(i-1)>posicao(i)  %encontrando ultimo maximo
    i=i-1;
  end
  maximo = posicao(i);

  while posicao(i-1)<posicao(i) %encontrando ultimo minimo
    i=i-1;
  end
  minimo = posicao(i);
  
else posicao(max-1)<posicao(max)
i = max;
  while posicao(i-1)<posicao(i) %encontrando ultimo minimo
   i=i-1;
  end
  minimo = posicao(i);
  
  while posicao(i-1)>posicao(i)  %encontrando ultimo maximo
    i=i-1;
  end
  maximo = posicao(i);
end


amplitude(j) = (maximo - minimo)/2
decibel(j) = 20*log(amplitude(j)-0.0049)

end

plot(wr,amplitude);
xlabel('\omega{rad/s}');
ylabel('Amplitude');
