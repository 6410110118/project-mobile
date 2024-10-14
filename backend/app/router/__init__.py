from . import item_people
from . import users
from . import authentications
from . import items
from . import item_activities
from . import groups
# from . import add_user_to_groups
from . import leaders
from . import peoples
from . import google_maps
from . import messages
from . import images


def init_router(app):

    app.include_router(users.router)
    app.include_router(authentications.router)
    app.include_router(items.router)
    app.include_router(item_activities.router)
    app.include_router(groups.router)
    # app.include_router(add_user_to_groups.router)
    app.include_router(leaders.router)
    app.include_router(peoples.router)
    app.include_router(google_maps.router)
    app.include_router(messages.router)
    app.include_router(images.router)
    app.include_router(item_people.router)