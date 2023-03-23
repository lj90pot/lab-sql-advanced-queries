/*Luis*/

use sakila; 

#Q1
select 
fa1.actor_id
,a.first_name as 'FistName_actor1'
,a.last_name as 'LastName_actor1'
,fa2.actor_id
,a2.first_name as 'FistName_actor2'
,a2.last_name as 'LastName_actor2'

from film_actor fa1 #Join
	inner join film_actor fa2 #self join on film_id and different actor id. Gives the films and the different actors in each film. 
		on fa1.film_id=fa2.film_id 
			and fa1.actor_id<>fa2.actor_id
	inner join actor a	#join to get the names for actor 1
		on fa1.actor_id=a.actor_id
	inner join actor a2 #join to get the names for actor 2
		on fa2.actor_id=a2.actor_id
;

#Q2
with master_table as (#this table has the films and the actors. I made a rank and rnk=1 is the actor that made more movies for each movie
	select 
		fc2.actor_id
		, fc2.film_id
        , t1.num_film
		, rank() over(partition by fc2.film_id order by fc2.actor_id desc ) as rnk
	from  film_actor fc2
		inner join (#Table with actor and number of films made
			select 
				actor_id
				, count(*) as 'num_film'
			from film_actor
			group by actor_id) as t1
		on fc2.actor_id=t1.actor_id
	order by film_id) 
select 
	film.title as 'movie_title'
    , concat(actor.first_name," ", actor.last_name) as 'actor_with_most_movies_produced'
    , mt.num_film as 'total_films_done_by_actor'
from master_table mt
	inner join film 
		on film.film_id=mt.film_id
	inner join actor
		on actor.actor_id=mt.actor_id
where rnk=1
;


