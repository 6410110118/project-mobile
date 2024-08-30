from . import users
from . import authentications
from . import items
from . import item_activities
from . import groups
from . import add_user_to_groups
from . import leaders
def init_router(app):

    app.include_router(users.router)
    app.include_router(authentications.router)
    app.include_router(items.router)
    app.include_router(item_activities.router)
    app.include_router(groups.router)
    app.include_router(add_user_to_groups.router)
    app.include_router(leaders.router)