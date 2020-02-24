select Navn, Levested
from Art
where Levested like 'oc' -- Opgave 1

select Monster.Navn, Art.Navn
from Monster, Art
where Art.Navn like 'Vampire' and levested like 'OC' -- Opgave 2, der er ikke nogen vampyrer

select Monster.Navn, Svaghed.Svaghed --Opgave 3
from Monster, Svaghed
where Monster.MonsterID =	(select Art.ArtID from Art where Art.Navn like 'Werewolf') 
							and Svaghed.SvaghedID = (select ArtSvaghed.Svaghed from ArtSvaghed where ArtSvaghed.Art = (select Art.ArtID from Art where Art.Navn like 'Werewolf'))

