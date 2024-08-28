from . import users
from . import authentications
from . import items
from . import item_activities
def init_router(app):

    app.include_router(users.router)
    app.include_router(authentications.router)
    app.include_router(items.router)
    app.include_router(item_activities.router)